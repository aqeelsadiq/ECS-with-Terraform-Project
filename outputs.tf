output "vpc-id" {
  value = aws_vpc.main-vpc.id
}

output "igw-id" {
  value = aws_internet_gateway.igw.id
}

output "pub-subnet1-id" {
  value = aws_subnet.pub-subnet1[*].id
}

output "pri-subnet1-id" {
  value = aws_subnet.pri-subnet1[*].id
}



output "securitygroup" {
  value = aws_security_group.webserver-sg.id

}

