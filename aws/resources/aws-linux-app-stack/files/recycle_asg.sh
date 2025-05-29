#!/bin/bash
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_SECURITY_TOKEN=$3
export Region=$4

AutoScalingGroupName=$5
ImageId=$6

if [ $ImageId == "" ]
then
  echo "Recycling is not required!"
  exit 0
fi 

OriginalMaxSize=$(aws autoscaling describe-auto-scaling-groups --region $Region --auto-scaling-group-names $AutoScalingGroupName --query 'AutoScalingGroups[*].{Max:MaxSize,Dc:DesiredCapacity}' --output text |awk '{print $1}')
OriginalDesiredCapacity=$(aws autoscaling describe-auto-scaling-groups --region $Region --auto-scaling-group-names $AutoScalingGroupName --query 'AutoScalingGroups[*].{Max:MaxSize,Dc:DesiredCapacity}' --output text |awk '{print $2}')

echo "OriginalMaxSize:$OriginalMaxSize - OriginalDesiredCapacity:$OriginalDesiredCapacity"

let NewMaxSize=2*$OriginalMaxSize
let NewDesiredCapacity=2*$OriginalDesiredCapacity

echo "NewMaxSize:$NewMaxSize - NewDesiredCapacity:$NewDesiredCapacity"

if [[ $NewDesiredCapacity -gt $NewMaxSize ]]
then
  $NewDesiredCapacity=$NewMaxSize
fi

aws autoscaling update-auto-scaling-group --region $Region --auto-scaling-group-name $AutoScalingGroupName --max-size $NewMaxSize --desired-capacity $NewDesiredCapacity

echo "Updating AutoScalingGroup:$AutoScalingGroupName..."

let InstanceCount=$(aws autoscaling describe-auto-scaling-groups --region $Region --auto-scaling-group-names $AutoScalingGroupName --query 'length(AutoScalingGroups[*].Instances[])')
while 
    [[ $InstanceCount -lt $NewDesiredCapacity ]]
do
    echo "Waiting for instance count:$InstanceCount to reach desired capacity:$NewDesiredCapacity..."
    sleep 25
let InstanceCount=$(aws autoscaling describe-auto-scaling-groups --region $Region --auto-scaling-group-names $AutoScalingGroupName --query 'length(AutoScalingGroups[*].Instances[])')
done     

echo "Finished launching new instances"

aws autoscaling update-auto-scaling-group --region $Region --auto-scaling-group-name $AutoScalingGroupName --max-size $OriginalMaxSize --desired-capacity $OriginalDesiredCapacity

echo "Updated $AutoScalingGroupName to Original Capacity:$OriginalDesiredCapacity"

