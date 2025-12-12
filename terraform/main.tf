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
