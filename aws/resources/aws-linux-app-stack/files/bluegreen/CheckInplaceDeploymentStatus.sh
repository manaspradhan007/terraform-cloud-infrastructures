#!/bin/bash
export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_SECURITY_TOKEN=$3
codepipelineName=$4
tenantRegion=$5

echo $codepipelineName
	
aws configure set default.region "$tenantRegion"
echo "tenant region : $tenantRegion"

sleep 1m
executionid=$(aws codepipeline get-pipeline-state --name $4 --query 'stageStates[?stageName==`Deploy`].latestExecution.pipelineExecutionId' --output text)
echo "Execution Id $executionid"

continue=1
while [ $continue -ne 0 ]; do

    sleep 3s
    echo "Checking Code deploy status"

	status=$(aws codepipeline get-pipeline-state --name $4 --query 'stageStates[?stageName==`Deploy`].latestExecution.status'  --output text)
    if [[ "$status" == "Succeeded" ]]; then
	   echo "This $4 pipeline is $status"
       echo "This $4 Code Pipeline got $status"
       continue=0
	  elif [[ "$status" == "Failed" ]]; then
	   echo "This $4 pipeline is $status"
       echo "This $4 Code pipeline $status"
       continue=0
    else
      echo "1st Attempt Code Pipeline is $status will wait for 3 Seconds and check status again.."
    fi
done

executionid=$(aws codepipeline get-pipeline-state --name $4 --query 'stageStates[?stageName==`Deploy`].latestExecution.pipelineExecutionId' --output text)
echo "Execution Id $executionid"

status=$(aws codepipeline get-pipeline-state --name $4 --query 'stageStates[?stageName==`Deploy`].latestExecution.status'  --output text)
if [ "$status" == "Failed" ]
then
	echo "2nd time retriggered the Code Pipeline $4"
	echo "2nd Attempt Execution ID"
	aws codepipeline retry-stage-execution --pipeline-name $4 --stage-name Deploy --pipeline-execution-id $executionid --retry-mode FAILED_ACTIONS
fi

continue=1
while [ $continue -ne 0 ]; do

    sleep 3s
    echo "2nd Attempt Checking Code deploy status"

	status=$(aws codepipeline get-pipeline-state --name $4 --query 'stageStates[?stageName==`Deploy`].latestExecution.status'  --output text)
    if [[ "$status" == "Succeeded" ]]; then
	   echo "This $4 pipeline is $status"
       echo "This $4 Code Pipeline got $status"
       continue=0
	  elif [[ "$status" == "Failed" ]]; then
	   echo "This $4 Code Pipeline got $status"
       echo "Code Pipeline $4 Failed on 2nd Attempt too..  Please check the Code Pipeline.. "
       continue=0
	   exit 1
    else
      echo "2nd Attempt Code Pipeline is $status.. Will wait for 3 Seconds and check status again.."
    fi
done

