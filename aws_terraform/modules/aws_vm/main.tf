# Gets the Packer AMI to use to create the EC2 instance
data "hcp_packer_artifact" "static_site_image" {
  bucket_name  = var.bucket_name
  channel_name = var.channel_name
  platform     = "aws"
  region       = var.region
}

# Creates the EC2 instance using the AMI
resource "aws_instance" "ec2_instance" {
  ami                         = data.hcp_packer_artifact.static_site_image.external_identifier
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [ "${var.vpc_security_group_id}" ]
  associate_public_ip_address = true
  # Sets hostname for the instance
  user_data = <<USER_DATA
    #cloud-config
    hostname: ${var.instance_name}
    manage_etc_hosts: true
USER_DATA

  tags = merge(
    var.tags, {
        Name   = var.instance_name
        Module = "aws_vm"
    }
  )
}