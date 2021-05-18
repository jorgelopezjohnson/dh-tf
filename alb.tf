module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "dh-smoothie-machine-local"

  load_balancer_type = "application"

  internal = false

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [
    aws_security_group.nginx_app_sg.id,
    aws_security_group.nginx_alb_sg.id
  ]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [for instance in aws_instance.nginx : {
        target_id = instance.id
        port      = 80
      }]
      health_check = {
        healthy_threshold   = 2
        interval            = 30
        unhealthy_threshold = 10
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  depends_on = [
    aws_instance.nginx
  ]
}


resource "aws_security_group" "nginx_alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = false
  }
}
