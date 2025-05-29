import json
import boto3
import sys
import json
import os
import ast
import time

def find_asg():
    print ("Executing Finding Not Active ASG..")
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    codedeploy = boto3.client('codedeploy')
    response = codedeploy.get_deployment_group(applicationName=codedeploy_applicationName,deploymentGroupName=deployment_GroupName)
    asgDetail=(response['deploymentGroupInfo']['autoScalingGroups'])
    return asgDetail


def finding_not_active_asg():
    asg1 = os.environ['asgone']
    asg2 = os.environ['asgtwo']
    asgDetail = find_asg()
    originalASG = (asgDetail[-1]['name'])  #Inactive ASG name which is serving request
    if originalASG == asg1:
        print (asg2)
        return asg2
    else:
        print (asg1)
        return asg1


def finding_active_asg():
    asg1 = os.environ['asgone']
    asg2 = os.environ['asgtwo']
    asgDetail = find_asg()
    originalASG = (asgDetail[-1]['name'])  #Original ASG name which is serving request
    if originalASG == asg1:
        print (asg2)
        return asg1
    else:
        print (asg1)
        return asg2

def copy_from_inactive_to_active_sa(asg,scheduledGroupActions):
    activeAsgName = finding_active_asg()
    for scheduledGroupAction in scheduledGroupActions :
        scName = scheduledGroupAction['ScheduledActionName']
        asg.put_scheduled_update_group_action(
                        AutoScalingGroupName=activeAsgName,
                        ScheduledActionName=scheduledGroupAction['ScheduledActionName'],
                        Time=scheduledGroupAction['Time'],
                        StartTime=scheduledGroupAction['StartTime'],
                        EndTime=scheduledGroupAction['EndTime'],
                        MinSize=scheduledGroupAction['MinSize'],
                        MaxSize=scheduledGroupAction['MaxSize'],
                        Recurrence=scheduledGroupAction['Recurrence'],
                        DesiredCapacity=scheduledGroupAction['DesiredCapacity'] )
        print ("Copying Scheduled actions from Inactive ASG to Active ASG")                    



def blue_green_asg_control(asgName):
    deployment_GroupName = os.environ['deploymentGroupName']
    codedeploy_applicationName = os.environ['applicationName']
    codedeploy = boto3.client('codedeploy')
    response = codedeploy.get_deployment_group(applicationName=codedeploy_applicationName,deploymentGroupName=deployment_GroupName)
    CheckWork=(response['deploymentGroupInfo'])
    status=CheckWork['lastAttemptedDeployment']
    RunStatus=(status['status'])
    if RunStatus == "InProgress":
        print ("Inprogess .............")
    else:
        print ("Code Deploy is in Not Running State..")
        tmpTGARN = os.environ['tgARNs']
        FinalTGARNs = tmpTGARN.split()
        asg = boto3.client('autoscaling')
        print ("Check is there any TG attached to ASG before removing..")
        
        res = asg.describe_load_balancer_target_groups(
                        AutoScalingGroupName=asgName,)
        Tglist= res['LoadBalancerTargetGroups']
        print (Tglist)
        if len(Tglist) == 0:
            print ("No Target Group has been Attached to this ASG")
            print (asgName)
        else:
            print ("Detach TGs from ASG..")
            res = asg.detach_load_balancer_target_groups(
                        AutoScalingGroupName=asgName,
                        TargetGroupARNs=FinalTGARNs,)
            print (res)
        print ("Change Min, Max Size 0 and Health Check Type to EC2..")
        resp = asg.update_auto_scaling_group(
	                    AutoScalingGroupName=asgName,
                        MinSize=0,
                        MaxSize=0,
                        HealthCheckType='EC2')
        print (resp)

        #Remove CodeDeploy Managed LifeCycle Hook from ASG
        print ("Removed Code Deploy Managed LifeCycle Hook")
        response = asg.describe_lifecycle_hooks(AutoScalingGroupName=asgName,)
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

        else:
            print ("Removing CodeDeploy-Managed Hook..")
            print (finalname[0])
            res = asg.delete_lifecycle_hook(LifecycleHookName=finalname[0],AutoScalingGroupName=asgName)
            print (res)
        
        #Removing Scheduled Actions
        response_sc = asg.describe_scheduled_actions(AutoScalingGroupName=asgName)
        print(response_sc)
        record = response_sc['ScheduledUpdateGroupActions']
        if not record:
            print("No Scheduled Actions Available on ASG")
        else:
            copy_from_inactive_to_active_sa(asg,record)
            for scheduledGroupAction in record :
                scName = scheduledGroupAction['ScheduledActionName']
                response_scd = asg.delete_scheduled_action(AutoScalingGroupName=asgName,ScheduledActionName=scName)
                print(response_scd)
                print("Scheduled Actions removed from Inactive ASG")
           
        print ("ASG Control lambda Execution Completed")

def lambda_handler(event, context):
    notUsedASG = finding_not_active_asg()
    res = blue_green_asg_control(notUsedASG)
    print (res)
    