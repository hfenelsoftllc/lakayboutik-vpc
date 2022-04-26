resource "aws_internet_gateway" "lakaydev-igw" {
  vpc_id = "${aws_vpc.lakaydev-vpc.id}"
  tags = {
    Name = "lakaydev-igw"
  }
}

resource "aws_route_table" "lakaydev-pub-crt" {
  vpc_id = "${aws_vpc.lakaydev-vpc.id}"

  route {
    #Assoc Subnet can be reach anywhere
    cidr_block = "0.0.0.0/0"

    #CRT uses this IGW to reach Internet
    gateway_id = "${aws_internet_gateway.lakaydev-igw.id}"
  }
  tags = {
    Name = "lakaydev-pub-crt"
  }
}

#Associate the CRT with Subnet
resource "aws_route_table_association" "lakaydev-crta-pub-sub-1" {
  subnet_id      = "${aws_subnet.lakaydev-sub-pub-1.id}"
  route_table_id = "${aws_route_table.lakaydev-pub-crt.id}"
}

#Security Group
resource "aws_security_group" "lakaydev-ssh-allowed" {
  vpc_id = "${aws_vpc.lakaydev-vpc.id}"
  #outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  #inbound ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["64.225.27.80/32"]
  }
  #inbound webserver
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lakaydev-ssh-allowed"
  }

}