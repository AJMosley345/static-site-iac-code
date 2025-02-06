# Sets nameservers of the domain on Porkbun to point to the AWS Zone
resource "porkbun_nameservers" "aws_nameservers" {
  domain = var.domain_name
  nameservers = concat(
    var.name_servers
  )
}