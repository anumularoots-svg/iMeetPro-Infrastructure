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
