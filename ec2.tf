# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#basic-example-using-ami-lookup
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "nginx_user_data" {
  template = "${file("templates/user_data.sh")}"
}

resource "aws_instance" "nginx" {
  count     = 2
  subnet_id = module.vpc.public_subnets[count.index]

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true

  user_data = data.template_file.nginx_user_data.rendered

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "nginx-${count.index}"
  }

  depends_on = [
    module.vpc
  ]

  security_groups = [
    aws_security_group.nginx_app_sg.id
  ]
}
