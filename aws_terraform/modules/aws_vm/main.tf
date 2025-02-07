# Gets the Packer AMI to use to create the EC2 instance
data "aws_ami" "packer_ami_image" {
  most_recent = true

  filter {
    name = "name"
    values = [ var.image_name ]
  }

  filter {
    name = "state"
    values = [ "available" ]
  }

  owners = [ "self" ]
}

# Creates the EC2 instance using the AMI
resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.packer_ami_image.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [ "${var.vpc_security_group_id}" ]
  associate_public_ip_address = true
  tags = merge(
    var.tags, {
        Name   = var.instance_name
        Module = "aws_vm"
    }
  )
}