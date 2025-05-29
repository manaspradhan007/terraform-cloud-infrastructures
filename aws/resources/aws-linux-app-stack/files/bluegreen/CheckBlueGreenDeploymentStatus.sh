#!/bin/bash
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_SECURITY_TOKEN=$3

codeDeployApplicationName=$4
DeploymentGroupName=$5
AsgOne=$6
AsgTwo=$7
ArtifactBucketName=$8
BlueGreenLambdaName=$9
tenantRegion=${10}

echo "CD Application Name : $codeDeployApplicationName"
echo "CD Deployment Group Name : $DeploymentGroupName"
echo "ASG1 Name : $AsgOne "
echo "ASG2 Name : $AsgTwo "
echo "S3 Artifacts Bucket Name : $ArtifactBucketName"
echo "Blue_Green Lambda Name : $BlueGreenLambdaName"


aws configure set default.region "$tenantRegion"
echo "tenant region : $tenantRegion"

echo "Checking Artifact file presence in s3.."
ArtifactsCheck=$(aws s3 ls s3://$ArtifactBucketName/api/ --output json)

echo "Printing Artifact files.."
echo
echo $ArtifactsCheck

if [ -z "$ArtifactsCheck" ]; then
	echo "Artifact file not available in s3.."
	exit 1
else
	echo "Preparing Both ASG for Blue-Green Deployment.."
	echo "Asg One Instances.."
	InstanceInASGOne=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AsgOne --query 'AutoScalingGroups[].Instances[].InstanceId' --output text)
	echo $InstanceInASGOne

	echo "Asg Two Instances.."
	InstanceInASGTwo=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AsgTwo --query 'AutoScalingGroups[].Instances[].InstanceId' --output text)
	echo $InstanceInASGTwo

	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AsgOne --min-size 0 --max-size 0 --health-check-type EC2 --health-check-grace-period 600
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AsgTwo --min-size 0 --max-size 0 --health-check-type EC2 --health-check-grace-period 600
	sleep 30s
	aws ec2 terminate-instances --instance-ids $InstanceInASGOne
	aws ec2 terminate-instances --instance-ids $InstanceInASGTwo

	echo "Check Instance status in ASG.."
	dowork=1
	while [ $dowork -ne 0 ]; do
		echo "exponential backoff Check the Instance terminated or not.. "
		InstanceInASGOne=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AsgOne --query 'AutoScalingGroups[].Instances[].InstanceId' --output text)
		InstanceInASGTwo=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AsgTwo --query 'AutoScalingGroups[].Instances[].InstanceId' --output text)
		echo "Instance in ASGOne : $InstanceInASGOne"
		echo
		echo "Instance in ASGTwo : $InstanceInASGTwo"
		echo	 
		
		if [ -z "$InstanceInASGOne" ] && [ -z "$InstanceInASGTwo" ] ; then
			echo "Old Instance Terminated.. proceedings Further.. "
			dowork=0

	else
			echo "To terminate the instances aws taking longer time than usual.. So will wait and retry.. "
			sleep 60
		fi
	done
	
	echo "Changing the ASG Min, Max"
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AsgOne --min-size 1 --max-size 1
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $AsgTwo --min-size 1 --max-size 1
	echo "Waiting for instance in service in ASG"
	sleep 5m

	retry=1
	while [ $retry -ne 0 ]; do
		echo "Invoke Lambda and check the status.."
		status=$(aws lambda invoke --function-name $BlueGreenLambdaName --payload '{ "name": "Blue_Green" }' response.json --query "StatusCode" --output text)
        cat response.json
		echo "Printing Invoke response : $status"

		if [ "$status" == "200" ]; then
			echo "Lambda Function Invoke success..  "
			retry=0
	
	else
			echo "Lambda is not in active state.. Hence waiting for One min and going to retry.."
			sleep 70
		fi
	done
	
	echo "Final Call to Check the lambda status.. "
	LambdaResponse1=$(aws lambda invoke --function-name $BlueGreenLambdaName --payload '{ "name": "Blue_Green" }' final.json --query "StatusCode" --output text)
	echo "Print Response Json file.."
	echo $LambdaResponse1
	cat final.json
	if [[ "$LambdaResponse1" == "200" ]]; then
		echo "Lambda got 200.."
		continue=1
		while [ $continue -ne 0 ]; do

			
			echo "Checking Code deploy status"
			sleep 5s
			
			status=$( aws deploy get-deployment-group --application-name $codeDeployApplicationName --deployment-group-name $DeploymentGroupName --query "deploymentGroupInfo.lastAttemptedDeployment.status" --output text)
			echo "Printing Status of Deployment : $status"
			if [[ "$status" == "Succeeded" ]]; then
				echo "Code Deploy finished."
				continue=0
			elif [[ "$status" == "Failed" ]]; then
				echo "Code Deploy Failed "
				continue=0
				exit 1
			elif [[ "$status" == "None" ]]; then
				echo "Blue Green Lambda Not Triggred properly and Deploymeny Not created.."
				continue=0
				exit 1
		else
				echo "Will wait for 5sec and check status again.."
			fi
		done
		
	
	else
		echo "Blue-Green Lambda failed.. "
		exit 1
			
	fi
fi