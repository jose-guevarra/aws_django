
/*
@todo - ebs volume size. uses 8gb by default. 4 min?
@todo - vault for creds?

*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region = var.aws_region
}


## AWS ASG Launch Config
resource "aws_launch_configuration" "alconf" {
  image_id               = "ami-0ebef2838fb2605b7"
  instance_type          = "t2.micro"
  key_name               = var.ami_key_pair_name
  security_groups        = [aws_security_group.instance.id]
  user_data              = file("user_data.sh")


  lifecycle {
    create_before_destroy = true
  }
}


data "aws_availability_zones" "all" {}


## AWS ASG
resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.alconf.id
  availability_zones   = data.aws_availability_zones.all.names
  
  min_size = 2
  max_size = 2

  load_balancers    = [aws_elb.elb.name]
  health_check_type = "ELB"

  # Make sure db exists before Django calls it.
  depends_on            = [aws_db_instance.maindb]  

  tag {
    key                 = "Name"
    value               = "tf-django"
    propagate_at_launch = true
  }
}


## AWS ELB
resource "aws_elb" "elb" {
  name               = "terraform-elb"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 300
    timeout             = 5
    healthy_threshold   = 2 
    unhealthy_threshold = 10
  }


  # This adds a listenter for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port 
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}

resource "aws_lb_cookie_stickiness_policy" "elb-stickiness" {
  name                     = "elb-stickiness-policy"
  load_balancer            = aws_elb.elb.id
  lb_port                  = 80
  cookie_expiration_period = 30
}




## Our Database
resource "aws_db_instance" "maindb" {
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0.20"
  instance_class          = "db.t2.micro"
  name                    = "django"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  identifier              = "djangodb"
  vpc_security_group_ids  = [aws_security_group.allow_rds.id]
}



## SECURITY GROUPS

resource "aws_security_group" "instance" {
  name = "terraform-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all inbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}


resource "aws_security_group" "elb" {
  name = "terraform-elb"
  
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # Inbound HTTP from everywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



## Only allow SQL from ASG group.
resource "aws_security_group" "allow_rds" {
  name          = "allow_rds"
  description   = "Allow SQL access."
  
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # Inbound allow sql
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    security_groups   = [aws_security_group.instance.id]
  }
}


