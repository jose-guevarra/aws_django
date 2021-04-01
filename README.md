# AWS HitCount


# Goal: In AWS, setup a page hit counter in Django.

These Terraform scripts will deploy a AWS load balancer, autoscale group, and EC2 Instance to host our Django application. Then the Ansible playbooks will deploy the Django application. 

Note: Instead of writing my own hit count application, I will be using the following Django app:
https://github.com/thornomad/django-hitcount

## Assumptions

1) You have AWS SSH Key pair generated for the EC2 instances
2) AWS cli is working so you can deploy using Terraform
3) You have Terraform installed
4) You have Ansible installed


## Use Terraform to deploy our Load Balancer, ASG, and EC2 Instance

1) Set the "ami_key_pair_name" in the tf/variables.tf file.

2) Deploy via Terraform.
> terraform init
>
> terraform apply -var-file="secret.tfvars"

Note the output value "clb_dns_name" which is the load balancer DNS name for the application.

3) Get Instance Public IP Address using ASG "name"
We need the public IP address of the EC2 instance in our autoscale group.  Use the autoscaling group name in the command below to get it's public IP Address (or get it by logging into AWS - EC2).

> sh aws-asg-instances-ip.sh


## Run Ansible to deploy Django-hitcount app

Set these values in the Ansible "hosts" file:
1. EC2 instance public IPs - "hosts".
2. Set SSH key file path and filename - ansible_ssh_private_key_file.
3. Set "clb_dns_name" to load balancer public domain name.
4. Set "aws_db_dns_name" to load balancer public domain name.
5. Set "aws_db_username" and "aws_db_password"

NOTE: The django-hitcount/ directory has the app source code.  You can apply updates then you need to create a new django-hitcount.tar.gz file to upload to changes to the app.
 
tar -czvf django-hitcount.tar.gz django-hitcount/

Now run Ansible playbooks below:

> ansible-playbook -i hosts deploy.yaml
>
> ansible-playbook -i hosts config_files.yaml

## Go to Load Balancer endpoint

You should now be able to visit the load balancer endpoint and see a page hit counter. It may take a minute for the load balancer to health check the instance and process requests correctly.

## Clean up

> terraform destroy -var-file="secret.tfvars"
