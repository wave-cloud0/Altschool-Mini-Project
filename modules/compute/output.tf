# --compute/output.tf---

output "ec2_ids" {
  value = aws_instance.instance[*].id
}

