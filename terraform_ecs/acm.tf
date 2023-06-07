resource "tls_private_key" "cohere" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cohere" {
  private_key_pem = tls_private_key.cohere.private_key_pem

  subject {
    common_name  = "${var.hostname}.${var.domain}"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cohere" {
  private_key      = tls_private_key.cohere.private_key_pem
  certificate_body = tls_self_signed_cert.cohere.cert_pem
}