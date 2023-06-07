resource "aws_route53_zone" "cohere_example_inter" {
    name = var.domain
    vpc{
        vpc_id = data.aws_vpc.cohere_vpc.id
    }
}

resource "aws_route53_record" "cohere"{
    zone_id = aws_route53_zone.cohere_example_inter.id
    name = var.hostname
    type = "A"

    alias {
      name = aws_lb.cohere_test_lb.dns_name
      zone_id = aws_lb.cohere_test_lb.zone_id
      evaluate_target_health = true
    }
}