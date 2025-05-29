# Example InSpec Profile
Name: terraform-aws-s3-bucket

This example shows the implementation of an ASG inspec profile.

ExpectedData required:
{
 "S3": {
    "S3BucketName": ""
  },
}

Controls Available:
1. S3 Bucket Exists
2. S3 Bucket not public