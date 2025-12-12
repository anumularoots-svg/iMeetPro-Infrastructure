# ============================================================================
# iMeetPro Infrastructure - Main Configuration
# ============================================================================

# Get AWS Account ID
data "aws_caller_identity" "current" {}

# ============================================================================
# Module 1: VPC
# ============================================================================

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# ============================================================================
# Module 2: Security Groups
# ============================================================================

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

# ============================================================================
# Module 3: Jenkins EC2
# ============================================================================

module "jenkins" {
  source = "./modules/jenkins"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_groups.jenkins_sg_id
  instance_type     = "t3.medium"
}

# ============================================================================
# Module 4: ECR Repositories
# ============================================================================

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# ============================================================================
# Module 5: EKS Cluster
# ============================================================================

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_nodes_sg_id    = module.security_groups.eks_nodes_sg_id
}

# ============================================================================
# Module 6: RDS MySQL
# ============================================================================

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_password        = var.db_password
}

# ============================================================================
# Module 7: ElastiCache Redis
# ============================================================================

module "elasticache" {
  source = "./modules/elasticache"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_sg_id        = module.security_groups.redis_sg_id
}

# ============================================================================
# Module 8: S3 Storage
# ============================================================================

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
  account_id   = data.aws_caller_identity.current.account_id
}

# ============================================================================
# Outputs
# ============================================================================

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "jenkins_private_key" {
  value     = module.jenkins.private_key_pem
  sensitive = true
}

output "ecr_frontend_url" {
  value = module.ecr.frontend_repository_url
}

output "ecr_backend_url" {
  value = module.ecr.backend_repository_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_database_name" {
  value = module.rds.database_name
}

output "redis_endpoint" {
  value = module.elasticache.primary_endpoint
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}
