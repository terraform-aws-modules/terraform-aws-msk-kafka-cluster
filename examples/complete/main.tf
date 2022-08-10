provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"

  secrets        = ["producer", "consumer"]
  bucket_postfix = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

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

resource "random_pet" "this" {
  length = 2
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

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
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules       = ["kafka-broker-tcp", "kafka-broker-tls-tcp"]
}

resource "aws_kms_key" "this" {
  description         = "KMS CMK for ${local.name}"
  enable_key_rotation = true

  tags = local.tags
}

resource "aws_secretsmanager_secret" "this" {
  for_each = toset(local.secrets)

  name        = "AmazonMSK_${each.value}_${random_pet.this.id}"
  description = "Secret for ${local.name} - ${each.value}"
  kms_key_id  = aws_kms_key.this.key_id

  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = toset(local.secrets)

  secret_id = aws_secretsmanager_secret.this[each.key].id
  secret_string = jsonencode({
    username = each.value,
    password = "${each.key}123!" # do better!
  })
}

resource "aws_secretsmanager_secret_policy" "this" {
  for_each = toset(local.secrets)

  secret_arn = aws_secretsmanager_secret.this[each.key].arn
  policy     = <<-POLICY
  {
    "Version" : "2012-10-17",
    "Statement" : [ {
      "Sid": "AWSKafkaResourcePolicy",
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "kafka.amazonaws.com"
      },
      "Action" : "secretsmanager:getSecretValue",
      "Resource" : "${aws_secretsmanager_secret.this[each.key].arn}"
    } ]
  }
  POLICY
}

module "s3_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${local.name}-${local.bucket_postfix}"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket for testing
  force_destroy = true

  attach_deny_insecure_transport_policy = true
  attach_lb_log_delivery_policy         = true # this allows log delivery

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

################################################################################
# MSK Cluster - Complete
################################################################################

module "msk_cluster" {
  source = "../.."

  name                   = local.name
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3
  enhanced_monitoring    = "PER_TOPIC_PER_PARTITION"

  broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_instance_type   = "kafka.m5.4xlarge"
  broker_node_security_groups = [module.security_group.security_group_id]

  broker_node_ebs_volume_size                    = 1000
  broker_node_ebs_provisioned_throughput_enabled = true
  broker_node_ebs_provisioned_volume_throughput  = 250

  encryption_in_transit_client_broker = "TLS"
  encryption_in_transit_in_cluster    = true

  configuration_name        = "complete-example-configuration"
  configuration_description = "Complete example configuration"
  configuration_server_properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }

  jmx_exporter_enabled    = true
  node_exporter_enabled   = true
  cloudwatch_logs_enabled = true
  s3_logs_enabled         = true
  s3_logs_bucket          = module.s3_logs_bucket.s3_bucket_id
  s3_logs_prefix          = local.name

  scaling_max_capacity = 512
  scaling_target_value = 80

  client_unauthenticated_access_enabled    = true
  client_authentication_sasl_scram         = true
  create_scram_secret_association          = true
  scram_secret_association_secret_arn_list = [for x in aws_secretsmanager_secret.this : x.arn]

  # schema registry
  schema_registries = {
    team_a = {
      name        = "team_a"
      description = "Schema registry for Team A"
    }
    team_b = {
      name        = "team_b"
      description = "Schema registry for Team B"
    }
  }
  schemas = {
    team_a_tweets = {
      schema_registry_name = "team_a"
      schema_name          = "tweets"
      description          = "Schema that contains all the tweets"
      compatibility        = "FORWARD"
      schema_definition    = "{\"type\": \"record\", \"name\": \"r1\", \"fields\": [ {\"name\": \"f1\", \"type\": \"int\"}, {\"name\": \"f2\", \"type\": \"string\"} ]}"
      tags                 = { Team = "Team A" }
    }
    team_b_records = {
      schema_registry_name = "team_b"
      schema_name          = "records"
      description          = "Schema that contains all the records"
      compatibility        = "FORWARD"
      schema_definition = jsonencode({
        type = "record"
        name = "r1"
        fields = [{
          name = "f1"
          type = "int"
          }, {
          name = "f2"
          type = "string"
          }, {
          name = "f3"
          type = "boolean"
        }]
      })
      tags = { Team = "Team B" }
    }
  }

  tags = local.tags
}
