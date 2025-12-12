# ============================================================================
# iMeetPro Infrastructure - ACM Module (SSL Certificate)
# ============================================================================

variable "domain_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# ============================================================================
# ACM Certificate
# ============================================================================

resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-cert-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# Outputs
# ============================================================================

output "certificate_arn" {
  value = aws_acm_certificate.main.arn
}

output "domain_validation_options" {
  value = aws_acm_certificate.main.domain_validation_options
}

output "certificate_status" {
  value = aws_acm_certificate.main.status
}
