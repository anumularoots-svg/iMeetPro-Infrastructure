# ============================================================================
# iMeetPro Infrastructure - Variables
# ============================================================================

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "imeetpro"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# ============================================================================
# RDS Variables
# ============================================================================

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# ============================================================================
# Domain Variables
# ============================================================================

variable "domain_name" {
  description = "Domain name for SSL certificate"
  type        = string
  default     = "lancieretech.imeetpro.com"
}
