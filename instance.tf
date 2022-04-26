resource "aws_instance" "lakaydev-web1" {
  ami           = lookup(var.AMI, var.AWS_REGION)
  instance_type = "t2.micro"

  #Attach the VPC
  subnet_id = "${aws_subnet.lakaydev-sub-pub-1.id}"

  #Attach the security group
  vpc_security_group_ids = ["${aws_security_group.lakaydev-ssh-allowed.id}"]

  #Public SSH key
  key_name = "${aws_key_pair.us-region-key-pair.id}"

  #Webserver installation
  provisioner "file" {
    source      = "${file("nginx.sh")}"
    destination = "/tmp/nginx.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/nginx.sh", "sudo /tmp/script.sh"
    ]
  }

  connection {
    user        = "${var.EC2_USER}"
    private_key = file("${var.PRIVATE_KEY_PATH}")
    host        = self.public_ip
  }

}

resource "aws_key_pair" "us-region-key-pair" {
  key_name   = "us-region-key-pair"
  public_key = "${file("${var.PUBLIC_KEY_PATH}")}"
}

output "ip" {
  value = "${aws_instance.lakaydev-web1.public_ip}"
}