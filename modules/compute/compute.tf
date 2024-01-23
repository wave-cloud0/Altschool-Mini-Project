# ---compute/compute.tf---

# create 3 instances
resource "aws_instance" "instance" {
  count                  = 3
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 30
  }
  key_name = "helloworld"

  user_data = var.user_data

  provisioner "local-exec" {
    command = "echo '${self.public_ip} ansible_user=ubuntu' >> inventory"
  }

  tags = {
    nath = "ec2"
  }
}

# Create a 30s delay in resource creation 
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.instance]

  create_duration = "30s"
}

# create a provisioner to run commands
resource "null_resource" "ansible_provisioner" {
  provisioner "local-exec" {
    command = " ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory webserverplaybook.yaml"
  }

  depends_on = [time_sleep.wait_30_seconds]
}
