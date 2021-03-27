#!/bin/bash

#@todo - command args for region and asg id


for ID in $(aws autoscaling describe-auto-scaling-instances --region us-west-1 --query AutoScalingInstances[].InstanceId --output text);
do


aws ec2 describe-instances --instance-ids $ID --region us-west-1 --query Reservations[].Instances[].PublicIpAddress --output text
done
