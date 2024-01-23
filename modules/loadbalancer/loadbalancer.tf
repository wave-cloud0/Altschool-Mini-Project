# ---loadbalancer/loadbalancer.tf---


# create a loadbalancer
resource "aws_lb" "nath_alb" {
  name               = "nick123abcalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.public_subnet_id, var.public_subnet_id2]
  ip_address_type    = "ipv4"

  tags = {
    nath = "alb"
  }
}

# create a listener for the loadbalancer
resource "aws_lb_listener" "nath_alb_listner" {
  load_balancer_arn = aws_lb.nath_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nath_alb_tg.arn
  }
}

# create a target group for the loadbalancer
resource "aws_lb_target_group" "nath_alb_tg" {
  name     = "nathalbtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 300
    path                = "/"
    protocol            = "HTTP"
    enabled             = true
    timeout             = 60
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

}

# create a tg-attachment-gro i.e attach instances/apps to the target group
resource "aws_lb_target_group_attachment" "test" {
  count            = length(var.instance_id)
  target_group_arn = aws_lb_target_group.nath_alb_tg.arn
  target_id        = var.instance_id[count.index]
  port             = 80

}
