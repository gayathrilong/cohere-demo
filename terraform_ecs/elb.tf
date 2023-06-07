resource "aws_lb" "cohere_test_lb" {
    name = var.load_balancer_name
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.cohere_lb_sg.id}"]
    subnets = [data.aws_subnet.cohere_public_a.id, data.aws_subnet.cohere_public_b.id]
}   

resource "aws_lb_target_group" "cohere_lb_tg"{
    name = "cohere-target-group"
    port = var.backend_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.cohere_vpc.id
    target_type = "ip"
    health_check {
      enabled = true
      path = var.health_check_path
    }
}

resource "aws_lb_listener" "cohere_front_end_http"{
     load_balancer_arn = aws_lb.cohere_test_lb.arn
     port = "80"
     protocol = "HTTP"
     
     default_action {
       type             = "redirect"
       redirect {
         port = "443"
         protocol = "HTTPS"
         status_code = "HTTP_301"
       }
    }
}

resource "aws_lb_listener" "cohere_front_end_https"{
     load_balancer_arn = aws_lb.cohere_test_lb.arn
     port = "443"
     protocol = "HTTPS"
     ssl_policy = "ELBSecurityPolicy-2016-08"
     certificate_arn = aws_acm_certificate.cohere.arn
     default_action {
       type             = "forward"
       target_group_arn = aws_lb_target_group.cohere_lb_tg.arn
       
  }
}

resource "aws_lb_listener_certificate" "cohere" {
  listener_arn    = aws_lb_listener.cohere_front_end_https.arn
  certificate_arn = aws_acm_certificate.cohere.arn
}
