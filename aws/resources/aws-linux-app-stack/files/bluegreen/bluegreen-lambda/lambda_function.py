import json
import boto3
import sys
import json
import os
import ast
import time
from botocore.client import Config


def create_bg_deployment(asgName): #Create the Blue/Green Deployment 
    config = Config(read_timeout=300)
    print ("Executing inside create BG deployment")
    print (asgName)
    deployment_GroupName = os.environ['deploymentGroupName']
    s3bucket_name = os.environ['artifactsBucketname']
    codedeploy_applicationName = os.environ['applicationName']
    artifactPath = os.environ['artifactPath']
    codedeploy = boto3.client('codedeploy',config=config)
    print ("Calling API to create the Blue_Green deployment..")
    response = codedeploy.create_deployment(
        applicationName=codedeploy_applicationName,
        deploymentGroupName=deployment_GroupName,
            revision={
        'revisionType': 'S3',
        's3Location': {
            'bucket': s3bucket_name,
            'key': artifactPath,
            'bundleType': 'zip'
                    },
                 },
            description='Blue Green Deployment API',
    
            targetInstances={
        'autoScalingGroups': [
            asgName,
                 ],
                    },
        autoRollbackConfiguration={
        'enabled': True,
        'events': ['DEPLOYMENT_FAILURE']
                },
            updateOutdatedInstancesOnly=False,
            fileExistsBehavior='DISALLOW',
	        ignoreApplicationStopFailures=False)
    
    return response
    
def checkGreenFleetASG():  #Find Replacement ASG nothing but Green Fleet ASG
    config = Config(read_timeout=300)
    print ("Executing inside checkGreenFleetASG..")
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    asg1 = os.environ['asgone']
    asg2 = os.environ['asgtwo']
    codedeploy = boto3.client('codedeploy', config=config)
    asg = boto3.client('autoscaling', config=config)
    response = codedeploy.get_deployment_group(applicationName=codedeploy_applicationName,deploymentGroupName=deployment_GroupName)
    asgDetail=(response['deploymentGroupInfo']['autoScalingGroups'])
    originalASG = (asgDetail[-1]['name'])  #Original ASG name which is serving request
    
    response2 = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[originalASG,])   #Get Min, Max, Desired Capacity from Original ASG
    org=response2['AutoScalingGroups']
    minsize = (org[0]['MinSize'])
    maxsize = (org[0]['MaxSize'])
    desiredCapacity = (org[0]['DesiredCapacity'])
    
    if originalASG == asg1:
        
        #Remove CodeDeploy Managed LifeCycle Hook from ASG
        response = asg.describe_lifecycle_hooks(AutoScalingGroupName=asg2,)
        AllList= (response['LifecycleHooks'])
        namelist=[]
        for i in AllList:
            namelist.append(i['LifecycleHookName'])
        print (namelist)
        start_letter='CodeDeploy-managed'
        finalname = list(filter(lambda x: x.startswith(start_letter), namelist)) 
        print(finalname)
        
        if len(finalname) == 0:
            print ("CodeDeploy-Managed Hook Already Removed..")
            res = asg.update_auto_scaling_group(AutoScalingGroupName=asg2, MinSize=minsize, MaxSize=maxsize, DesiredCapacity=desiredCapacity)
            print (res)
            return asg2
        else:
            print ("Removing CodeDeploy-Managed Hook..")
            print (finalname[0])
            res = asg.delete_lifecycle_hook(LifecycleHookName=finalname[0],AutoScalingGroupName=asg2)
            print (res)
            time.sleep (3)
            res = asg.update_auto_scaling_group(AutoScalingGroupName=asg2, MinSize=minsize, MaxSize=maxsize, DesiredCapacity=desiredCapacity)
            print (res)
            return asg2
        
    else:
        
        response = asg.describe_lifecycle_hooks(AutoScalingGroupName=asg1,)
        AllList= (response['LifecycleHooks'])
        namelist=[]
        for i in AllList:
            namelist.append(i['LifecycleHookName'])
        print (namelist)
        start_letter='CodeDeploy-managed'
        finalname = list(filter(lambda x: x.startswith(start_letter), namelist)) 
        print(finalname)
        
        if len(finalname) == 0:
            print ("CodeDeploy-Managed Hook Already Removed..")
            res = asg.update_auto_scaling_group(AutoScalingGroupName=asg1, MinSize=minsize, MaxSize=maxsize, DesiredCapacity=desiredCapacity)
            print (res)
            return asg1
        else:
            print ("Removing CodeDeploy-Managed Hook..")
            res = asg.delete_lifecycle_hook(LifecycleHookName=finalname[0],AutoScalingGroupName=asg1)
            print (res)
            time.sleep (3)
            res = asg.update_auto_scaling_group(AutoScalingGroupName=asg1, MinSize=minsize, MaxSize=maxsize, DesiredCapacity=desiredCapacity)
            print (res)
            return asg1
            
def check_Green_fleet_asg_instance_status(AsgName): #Make sure instance is in In-Service state
    print ("Checking ASG instance status..")
    config = Config(read_timeout=300)
    asg = boto3.client('autoscaling', config=config)
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    codedeploy = boto3.client('codedeploy',config=config)
    print ("Before Go to While loop waiting for 60sec..")
    time.sleep(60)
    cont=1
    while cont != 0:
        finalstate=[]
        response = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[AsgName,],)
        asgDetails=(response['AutoScalingGroups'])
        instanceDetails=(asgDetails[0]['Instances'])
        for i in instanceDetails:
            finalstate.append(i['LifecycleState'])
        if 'Pending' not in finalstate:
            print ("All instace got inservice.......")
            cont=0
        else:
            print ("Instance is in pending State....")
    
        
def create_deployment_group(): # Create the Code Deployment Group
    config = Config(read_timeout=300)
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    asg1 = os.environ['asgone']
    asg2 = os.environ['asgtwo']
    IAMRoleARN = os.environ['codedeployIAMRoleARN']
    TargetGroupName = os.environ['ApplicationTargetGroupName']
    SNSTriggerARN = os.environ['SNSArn']
    codedeploy = boto3.client('codedeploy', config=config)
    res = codedeploy.list_deployment_groups(applicationName=codedeploy_applicationName)
    deployment_group_list = res['deploymentGroups']
    print (deployment_group_list)
    if len(deployment_group_list) == 0:  #Check already Deployment group present. 
        response = codedeploy.create_deployment_group(
        applicationName=codedeploy_applicationName,
        deploymentGroupName=deployment_GroupName,
        deploymentConfigName='CodeDeployDefault.AllAtOnce',
        autoScalingGroups=[asg1],
        serviceRoleArn=IAMRoleARN,
        autoRollbackConfiguration={'enabled': True,'events': ['DEPLOYMENT_FAILURE',]},
        deploymentStyle={'deploymentType': 'BLUE_GREEN','deploymentOption': 'WITH_TRAFFIC_CONTROL'},
		triggerConfigurations=[
         {
            'triggerName': 'DeploymentSuccessTrigger',
            'triggerTargetArn': SNSTriggerARN ,
            'triggerEvents': [
                'DeploymentSuccess','DeploymentRollback',
            ]
         },],
		
        blueGreenDeploymentConfiguration={
            'terminateBlueInstancesOnDeploymentSuccess': {
                'action': 'KEEP_ALIVE',
                'terminationWaitTimeInMinutes': 0
            },
            'deploymentReadyOption': {
                'actionOnTimeout': 'CONTINUE_DEPLOYMENT',
                'waitTimeInMinutes': 0
            },
            'greenFleetProvisioningOption': {
                'action': 'DISCOVER_EXISTING'
            }},
        loadBalancerInfo={'targetGroupInfoList': [{'name': TargetGroupName }]})
        
        print (response)
        return response
    else:
        print ("Deployment Group Already Exists..")
        
    
        

def lambda_handler(event, context):
    config = Config(read_timeout=300)
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    codedeploy = boto3.client('codedeploy',config=config)
    print ("Calling Create Deployment Group..")
    res = create_deployment_group()
    print (res)
    
    res = codedeploy.list_deployments(applicationName=codedeploy_applicationName,deploymentGroupName=deployment_GroupName)
    DeploymentList = res['deployments']
    print ("Printing Deployment List")
    print (DeploymentList)
    if len(DeploymentList) == 0 :
        print ("Running lambda for 1st provision.. ")
        getgreenFleetASG = checkGreenFleetASG()
        print (getgreenFleetASG)
        res = check_Green_fleet_asg_instance_status(getgreenFleetASG)
        print (res)
        deploy_id = create_bg_deployment(getgreenFleetASG)
        print (deploy_id)
    else:
        response = codedeploy.get_deployment_group(applicationName=codedeploy_applicationName,deploymentGroupName=deployment_GroupName)
        CheckWork=(response['deploymentGroupInfo'])
        status=CheckWork['lastAttemptedDeployment']
        RunStatus=(status['status'])
        if RunStatus == "InProgress":
            print ("Code Deploy Running state, So skipping to run lambda function..")
        else:
            print ("Code Deploy is in Not Running State.. Starting the lambda Function..")
            getgreenFleetASG = checkGreenFleetASG()
            print (getgreenFleetASG)
            res = check_Green_fleet_asg_instance_status(getgreenFleetASG)
            print (res)
            deploy_id = create_bg_deployment(getgreenFleetASG)
            print (deploy_id)
            
        
        
 
    

    
    
    
    

    
    
    
