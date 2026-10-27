# =============================================================================
# main.tf – Root Terraform configuration
# AI-Powered E-Commerce DevOps & Cloud-Native Delivery Platform
# =============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state backend (uncomment and configure after creating the S3 bucket)
  # backend "s3" {
  #   bucket         = "davine-terraform-state"
  #   key            = "ecommerce-platform/terraform.tfstate"
  #   region         = var.aws_region
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "AI-Powered-ECommerce-DevOps"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# ── VPC ──────────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr          = var.vpc_cidr
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  availability_zones = var.availability_zones
  environment       = var.environment
}

# ── EC2 Application Server ────────────────────────────────────────
module "app_server" {
  source = "./modules/ec2"

  instance_type    = var.instance_type
  ami_id           = var.ami_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.app_sg_id
  key_name         = var.key_name
  environment      = var.environment
}

# ── RDS Database ──────────────────────────────────────────────────
module "database" {
  source = "./modules/rds"

  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_id = module.vpc.db_sg_id
  environment      = var.environment
}

# ── EKS Cluster ───────────────────────────────────────────────────
module "eks" {
  source = "./modules/eks"

  cluster_name     = "${var.environment}-ecommerce-cluster"
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_id = module.vpc.app_sg_id
  node_group_size  = var.eks_node_group_size
  environment      = var.environment
}
