######################################################################################
#                         AUTO SCALING GROUP CONFIGURATION
######################################################################################

resource "aws_launch_configuration" "demo_instance_auto" {
  name            = "demo_instance_auto"
  image_id        = var.image_id
  instance_type   = var.instance_type
  key_name        = var.keypair
  security_groups = [aws_security_group.ec2_sg.id]
  user_data       = base64encode(file("apache.sh"))
}

resource "aws_autoscaling_group" "asg" {
  max_size                  = 4
  desired_capacity          = 2
  min_size                  = 0
  health_check_grace_period = 300
  force_delete              = true
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.alb_tg.arn]
  depends_on                = [aws_launch_configuration.demo_instance_auto]
  launch_configuration      = aws_launch_configuration.demo_instance_auto.id
  vpc_zone_identifier       = [aws_subnet.public_subnet_1b, aws_subnet.public_subnet_1c.id]

  timeouts {
    delete = "15m"
  }
}


