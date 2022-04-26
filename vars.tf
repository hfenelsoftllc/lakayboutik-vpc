variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMI" {
  type = map(string)
  default = {
    us-east-1 = "ami-0c4f7023847b90238"
    us-west-2 = "ami-0cb4e786f15603b0d"
  }
}

variable "PUBLIC_KEY_PATH" {
  default = "us-region-key-pair.pub"
}

variable "PRIVATE_KEY_PATH" {
  default = "us-region-key-pair"
}

variable "EC2_USER" {
  default = "EC2_USER"
}