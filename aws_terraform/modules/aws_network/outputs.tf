output "vpc_id" {
  value = aws_vpc.am_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.am_public_subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.am_private_subnet.id
}
output "security_group_id" {
  value = aws_security_group.am_security_group.id
}