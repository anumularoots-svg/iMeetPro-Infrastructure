# ============================================================================
# iMeetPro Infrastructure - Main Configuration
# ============================================================================

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

output "jenkins_sg_id" {
  value = module.security_groups.jenkins_sg_id
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "eks_nodes_sg_id" {
  value = module.security_groups.eks_nodes_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "redis_sg_id" {
  value = module.security_groups.redis_sg_id
}
