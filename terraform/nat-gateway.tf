resource "aws_eip" "nat_az1" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-az1"
  }
}

resource "aws_eip" "nat_az2" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-az2"
  }
}

resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name = "nat-gateway-az1"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id

  tags = {
    Name = "nat-gateway-az2"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}