import boto3
import json
import logging
import datetime
import requests
import time
import os
from botocore.client import Config

# Create AWS clients
cw = boto3.client('cloudwatch')
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# Retrieves instance id from CloudWatch event
def get_instance_id(event):
    try:
        return event['detail']['EC2InstanceId']
    except KeyError as err:
        LOGGER.error(err)
        return False

def get_metadata(event):
    try:
        return event['detail']['NotificationMetadata']
    except KeyError as err:
        LOGGER.error(err)
        return False

def sat_dereg(event, context):
    print("===================")
    print(event)
    ssm_document_name = os.environ['ssm_document_name']
    region = os.environ['region']
    print(ssm_document_name)
    instanceid = (get_instance_id(event)).strip()
    metadata = get_metadata(event)
    print(instanceid)
    print("===================")
    LOGGER.info("instance-id: %s" % instanceid)
    LOGGER.info("metadata: %s" % metadata)
    ssm_client = boto3.client('ssm', region_name=region)
    print(ssm_client)
    response = ssm_client.send_command(InstanceIds=[instanceid], DocumentName=ssm_document_name, Parameters={},TimeoutSeconds=600)

def fetch_sts_params(master_tenant_environment):

    config = Config(connect_timeout=30, read_timeout=50, retries={'max_attempts': 0})
    sm_client = boto3.client(
        'secretsmanager',
        config=config
    )

    secret_name_dev = 'arn:aws:secretsmanager:us-east-1:348141368423:secret:_OPS_COMMON_PARAMS-5NqA1I'
    secret_name_prod = 'arn:aws:secretsmanager:us-east-1:824851886736:secret:_OPS_COMMON_PARAMS-0NEUru'
    
    if master_tenant_environment == 'PROD':
        secret_name = secret_name_prod
    else:
        secret_name = secret_name_dev
        
    response = sm_client.get_secret_value(
        SecretId=secret_name
    )

    secrets = response['SecretString']
    secrets = json.loads(secrets)

    sts_auth = {}
    sts_auth['sts_username'] = secrets['sts_username']
    sts_auth['sts_password'] = secrets['sts_password']
    sts_auth['sts_ad_testflag'] = secrets['sts_ad_testflag']
    return sts_auth

def sts_dereg(event, context):
    ec2instanceid = event['detail']['EC2InstanceId']
    asgs = event['detail']['AutoScalingGroupName']
    tenant_id = os.environ['tenant_id']
    master_tenant_environment = os.environ['master_tenant_environment']
    
    sts_params = fetch_sts_params(master_tenant_environment)
    
    sts_username = sts_params['sts_username']
    sts_password = sts_params['sts_password']
    sts_ad_testflag = sts_params['sts_ad_testflag']
    
    login_headers = {"Content-Type": "application/json"}
    login_parameters = {"username": sts_username, "password": sts_password}
    
    print("Received params")
    
    login_response = requests.post("https://<url here>/api/v2/Authentication/Login", headers = login_headers, json = login_parameters)
        
    jwt = login_response.json()
    jwt = jwt['Jwt']
    
    print("Generated token")
    
    time.sleep(10)
    
    remove_headers = {"Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer "+jwt}
    remove_parameters = {
        "appid": "",
        "tenantid": tenant_id,
        "instanceid": ec2instanceid,
        "testflag": sts_ad_testflag
    }
        
    remove_response = requests.post("https://<url-here>/api/v2/ActiveDirectory//DeleteInstance", headers=remove_headers, data=remove_parameters)

    print("response: ")
    print(remove_response.text)
    return remove_response.text
    

def lambda_handler(event, context):
    
    print("In Lambda Handler")
    try:
        print("Calling Sattelite DeReg")
        sat_dereg(event, context)
    except:
        print("Failed in Sattelite DeReg")

    try:
        print("Calling STS Instance DeReg")
        sts_dereg(event, context)
    except:
        print("Failed in STS Instance DeReg")
