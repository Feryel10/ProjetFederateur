resource "aws_acm_certificate" "ssl" {

  provider = aws.east

  domain_name = "${local.env.record_name}.${local.env.domain_name}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ssl_validation" {

  provider = aws.east

  certificate_arn = aws_acm_certificate.ssl.arn

  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}