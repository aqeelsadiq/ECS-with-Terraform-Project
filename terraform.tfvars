aws-region        = "us-west-1"
resource-name     = "demo-aqeel"
vpc-cidr          = "10.0.0.0/16"
ec2-ami           = "ami-0d53d72369335a9d6"
ec2-instance-type = "t2.micro"
# task-definition-name = "demo-aqeel-task-definition"
pub-subnet = [
  {
    name              = "demo-aqeel-Public-Subnet-1"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-1a"
  },
  {
    name              = "demo-aqeel-Public-Subnet-2"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-west-1c"
  }
]

pri-subnet = [
  {
    name              = "demo-aqeel-Private-Subnet-1"
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-west-1a"
  },
  {
    name              = "demo-aqeel-Private-Subnet-2"
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-west-1c"
  }
]
