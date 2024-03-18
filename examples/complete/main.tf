provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr            = "10.0.0.0/16"
  vpc_connection_cidr = "10.1.0.0/16"
  azs                 = slice(data.aws_availability_zones.available.names, 0, 3)

  secrets = ["producer", "consumer"]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-msk-kafka-cluster"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# MSK Cluster - Complete
################################################################################

module "msk_cluster" {
  source = "../.."

  name                   = local.name
  kafka_version          = "3.5.1"
  number_of_broker_nodes = 3
  enhanced_monitoring    = "PER_TOPIC_PER_PARTITION"

  broker_node_client_subnets = module.vpc.private_subnets
  broker_node_connectivity_info = {
    public_access = {
      type = "DISABLED"
    }
    vpc_connectivity = {
      client_authentication = {
        tls = false
        sasl = {
          iam   = false
          scram = true
        }
      }
    }
  }
  broker_node_instance_type   = "kafka.m5.large"
  broker_node_security_groups = [module.security_group.security_group_id]
  broker_node_storage_info = {
    ebs_storage_info = { volume_size = 100 }
  }

  vpc_connections = {
    connection_one = {
      authentication  = "SASL_SCRAM"
      vpc_id          = module.vpc_connection.vpc_id
      client_subnets  = module.vpc_connection.private_subnets
      security_groups = [module.vpc_connection_security_group.security_group_id]
    }
  }

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

  client_authentication = {
    sasl = { scram = true }
  }
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
        fields = [
          {
            name = "f1"
            type = "int"
          },
          {
            name = "f2"
            type = "string"
          },
          {
            name = "f3"
            type = "boolean"
          }
        ]
      })
      tags = { Team = "Team B" }
    }
  }

  # cross account cluster policy
  create_cluster_policy = true
  cluster_policy_statements = {
    basic = {
      sid = "basic"
      principals = [
        {
          type = "AWS"
          # identifiers would be cross account IDs to provide access to the cluster
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      ]
      actions = [
        "kafka:CreateVpcConnection",
        "kafka:GetBootstrapBrokers",
        "kafka:DescribeCluster",
        "kafka:DescribeClusterV2"
      ]
      effect = "Allow"
    }
    firehose = {
      sid = "firehose"
      principals = [
        {
          type        = "Service"
          identifiers = ["firehose.amazonaws.com"]
        }
      ]
      actions = [
        "kafka:CreateVpcConnection",
        "kafka:GetBootstrapBrokers",
        "kafka:DescribeCluster",
        "kafka:DescribeClusterV2"
      ]
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "random_pet" "this" {
  length = 2
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules = [
    "kafka-broker-tcp",
    "kafka-broker-tls-tcp",
    "kafka-broker-sasl-scram-tcp"
  ]

  tags = local.tags
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

  bucket_prefix = local.name

  acl                      = "log-delivery-write"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"


  # Allow deletion of non-empty bucket for testing
  force_destroy = true

  attach_deny_insecure_transport_policy = true
  attach_lb_log_delivery_policy         = true # this allows log delivery

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
# VPC Connections
################################################################################

module "vpc_connection_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-vpc-connection"
  description = "Security group for ${local.name} VPC Connection"
  vpc_id      = module.vpc_connection.vpc_id

  ingress_cidr_blocks = module.vpc_connection.private_subnets_cidr_blocks
  ingress_rules = [
    "kafka-broker-tcp",
    "kafka-broker-tls-tcp"
  ]
  #  multi-VPC network load balancer is listening on the 14001-14100 port ranges
  ingress_with_cidr_blocks = [
    {
      from_port   = 14001
      to_port     = 14003
      protocol    = "tcp"
      description = "Service name"
      cidr_blocks = module.vpc_connection.vpc_cidr_block
    }
  ]

  tags = local.tags
}

module "vpc_connection" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc-connection"
  cidr = local.vpc_connection_cidr

  azs              = local.azs
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_connection_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_connection_cidr, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_connection_cidr, 8, k + 6)]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = local.tags
}
