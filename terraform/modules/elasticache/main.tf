# ============================================================================
# iMeetPro Infrastructure - ElastiCache Redis Module
# ============================================================================

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "redis_sg_id" {
  type = string
}

# ============================================================================
# ElastiCache Subnet Group
# ============================================================================

resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.project_name}-redis-subnet-${var.environment}"
  description = "Redis subnet group for ${var.project_name}"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-redis-subnet-${var.environment}"
  }
}

# ============================================================================
# ElastiCache Redis Cluster
# ============================================================================

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-redis-${var.environment}"
  description          = "Redis cluster for ${var.project_name}"

  # Engine
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t3.medium"
  port                 = 6379

  # Cluster Config
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true

  # Network
  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [var.redis_sg_id]

  # Settings
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  # Maintenance
  maintenance_window       = "mon:05:00-mon:06:00"
  snapshot_window          = "03:00-04:00"
  snapshot_retention_limit = 7

  # Auto upgrade
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.project_name}-redis-${var.environment}"
  }
}

# ============================================================================
# Outputs
# ============================================================================

output "primary_endpoint" {
  value = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "reader_endpoint" {
  value = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "port" {
  value = aws_elasticache_replication_group.main.port
}
