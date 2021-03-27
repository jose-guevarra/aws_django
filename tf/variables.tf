

variable "aws_region" {
  description = "The region to create our infrastructure"
  type        = string
  default     = "us-west-1"
}

variable "server_port" {
  description = "The port the web server will use for HTTP requests"
  type        = number
  default     = 80
}


variable "elb_port" {
  description     = ""
  type            = number
  default         = 80

}

variable "ami_key_pair_name" { 
  description = "AWS EC2 key pair name."
  type        = string
  sensitive   = true
}


variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}


