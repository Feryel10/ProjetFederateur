############################################
# DATA - ROUTE53 ZONE
############################################
locals {
  domain_name = "feriel.online"
  www_domain  = "www.feriel.online"
}
data "aws_route53_zone" "zone" {

  name         = local.domain_name
  private_zone = false
}

############################################
# S3 STATIC WEBSITE
############################################

resource "aws_s3_bucket" "site" {
  bucket        = "www.feriel.online"
  force_destroy = true
}

############################################
# ACM CERTIFICATE (MANDATORY US-EAST-1)
############################################

resource "aws_acm_certificate" "cert" {
  provider          = aws.use1
  domain_name       = local.www_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

############################################
# ROUTE53 DNS VALIDATION RECORDS
############################################

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

############################################
# ACM VALIDATION FINAL STEP
############################################

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

