variable "aws-region" {}
variable "resource-name" {}
variable "vpc-cidr" {}
variable "pub-subnet" {
  type = list(map(string))
}
variable "pri-subnet" {
  type = list(map(string))
}
variable "ec2-ami" {}
variable "ec2-instance-type" {}
# variable "task-definition-name" {}