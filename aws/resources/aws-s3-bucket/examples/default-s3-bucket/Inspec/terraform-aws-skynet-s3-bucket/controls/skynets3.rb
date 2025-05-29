title 'MicroService: S3 Bucket 0.12.9 Upgrade'

path = Dir.pwd
info = File.read("#{path}/terraform-aws-s3-bucket.yml")
data = yaml(content: info).params

puts data['default_s3_bucket_example_s3_bucket_name']

control 'S3 Bucket Exists' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_bucket(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do 
    it { should exist }
    it { should_not be_public }
  end
end

control 'S3 Bucket not public' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_bucket(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do 
    it { should_not be_public }
  end
end

control 'S3 Bucket Expiration days' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do
    its ('expiration_days'){ should eq data["default_s3_bucket_example_s3_bucket_expiration_days"].to_i}
  end
end

control 'S3 Glacier non_concurrent expiration days' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do
    its ('noncurrent_version_expiration_days'){ should eq 1}
  end
end

control 'S3 Glacier abort_multipart_upload expiration days' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do
    its ('abort_incomplete_multipart_expiration_days'){ should eq 2}
  end
end

control 'S3 Glacier transition creation days' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do
    its ('transition_days_after_creation'){ should eq data["default_s3_bucket_example_s3_bucket_transition_days"].to_i}
  end
end

control 'S3 Glacier storage class' do                       
  impact 1.0                            
  title 'check for existance of bucket'          
  describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: data['default_s3_bucket_example_s3_bucket_name']) do
    its ('storage_class'){ should eq data["default_s3_bucket_example_s3_bucket_storage_class"]}
  end
end

