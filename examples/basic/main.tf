provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "example-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Example     = local.name
    Environment = "dev"
  }
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3"

  name = local.name
  cidr = "10.0.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_rules       = ["kafka-broker-tcp", "kafka-broker-tls-tcp"]
}

################################################################################
# MSK Cluster - Disabled
################################################################################

module "msk_cluster_disabled" {
  source = "../.."

  create = false
}

################################################################################
# MSK Cluster - Default
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

  tags = local.tags
}
