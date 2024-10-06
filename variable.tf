variable "aws-region" {}
variable "resource-name" {}
variable "vpc-cidr" {}
variable "pub-subnet" {
  type = list(map(string))
}
variable "pri-subnet" {
  type = list(map(string))
}
variable "task-definition-name" {}
