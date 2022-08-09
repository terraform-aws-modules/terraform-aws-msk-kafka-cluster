provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"

  bucket_postfix = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  connector_external_url = "https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/1.8.0.Final/debezium-connector-postgres-1.8.0.Final-plugin.tar.gz"
  connector              = "debezium-connector-postgres/debezium-connector-postgres-1.8.0.Final.jar"

  tags = {
    Example     = local.name
    Environment = "dev"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "~> 3.0"

  name = local.name
  cidr = "10.0.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  map_public_ip_on_launch      = false

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  enable_flow_log                      = true
  flow_log_destination_type            = "cloud-watch-logs"
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  flow_log_log_format                  = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr} $${region} $${az-id} $${sublocation-type} $${sublocation-id}"

  tags = local.tags
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  # version = "~> 4.0"

  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules       = ["kafka-broker-tcp", "kafka-broker-tls-tcp"]
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  # version = "~> 3.0"

  bucket = "${local.name}-${local.bucket_postfix}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  # Allow deletion of non-empty bucket for testing
  force_destroy = true

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_bucket_object" "debezium_connector" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = local.connector
  source = local.connector

  depends_on = [
    null_resource.debezium_connector
  ]
}

resource "null_resource" "debezium_connector" {
  provisioner "local-exec" {
    command = <<-EOT
    wget -c ${local.connector_external_url} -O connector.tar.gz \
    && tar -zxvf connector.tar.gz  ${local.connector} \
    && rm *.tar.gz
    EOT
  }
}

################################################################################
# MSK Cluster
################################################################################

module "msk_cluster" {
  source = "../.."

  name                   = local.name
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3

  broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_ebs_volume_size = 20
  broker_node_instance_type   = "kafka.t3.small"
  broker_node_security_groups = [module.security_group.security_group_id]

  # Connect custom plugin(s)
  connect_custom_plugins = {
    debezium = {
      name         = "debezium-postgresql"
      description  = "Debezium PostgreSQL connector"
      content_type = "JAR"

      s3_bucket_arn     = module.s3_bucket.s3_bucket_arn
      s3_file_key       = aws_s3_bucket_object.debezium_connector.id
      s3_object_version = aws_s3_bucket_object.debezium_connector.version_id

      timeouts = {
        create = "20m"
      }
    }
  }

  # Connect worker configuration
  create_connect_worker_configuration           = true
  connect_worker_config_name                    = local.name
  connect_worker_config_description             = "Example connect worker configuration"
  connect_worker_config_properties_file_content = <<-EOT
  key.converter=org.apache.kafka.connect.storage.StringConverter
  value.converter=org.apache.kafka.connect.storage.StringConverter
  EOT

  tags = local.tags
}
