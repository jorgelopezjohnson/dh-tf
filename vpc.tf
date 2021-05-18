module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "daily-harvest"
  cidr = "172.90.0.0/16"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["172.90.101.0/24", "172.90.102.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  create_igw = true
}
