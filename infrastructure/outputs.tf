output "certificate_arn" {
  value = aws_acm_certificate.ssl.arn
}

output "certificate_status" {
  value = aws_acm_certificate.ssl.status
}

output "domain_name" {
  value = "${local.env.record_name}.${local.env.domain_name}"
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.main.zone_id
}