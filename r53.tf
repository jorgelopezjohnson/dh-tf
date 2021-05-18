resource "aws_route53_zone" "smoothiemachine_private_zone" {
  name = "smoothiemachine.local"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "nginx_ec2_dns" {
  count   = 2
  name    = "web${count.index}.smoothiemachine.local"
  zone_id = aws_route53_zone.smoothiemachine_private_zone.zone_id
  type    = "A"
  ttl     = "300"
  records = [aws_instance.nginx[count.index].private_ip]
}

resource "aws_route53_record" "nginx_alb" {
  zone_id = aws_route53_zone.smoothiemachine_private_zone.zone_id
  name    = "dh.smoothiemachine.local"
  type    = "A"

  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = false
  }
}
