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

output "load-balanncer-arn" {
  value = aws_lb.load-balancer.arn
}

output "securitygroup" {
  value = aws_security_group.webserver-sg.id

}

output "target-group-arn" {
  value = aws_lb_target_group.TG.arn

}

output "alb-dns" {
  value = aws_lb.load-balancer.dns_name

}