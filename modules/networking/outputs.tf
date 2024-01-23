# ---networking/outputs.tf---

output "security_group_id" {
  value = aws_security_group.Webserver-sg.id
}

output "public_subnet_id" {
  value = aws_subnet.nath_public_subnet.id
}

output "public_subnet_id2" {
  value = aws_subnet.nath_public_subnet2.id
}
output "vpc_id" {
  value = aws_vpc.nath_vpc.id
}
