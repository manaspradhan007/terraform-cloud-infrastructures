title 'Linux implementation'

path = Dir.pwd
puts "printing path"
puts path
info = File.read("#{path}/terraform-aws-standard-linux-server.yml")
data=yaml(content: info).params

instance_id = data["default_linux_server_example_instance_id"]
key_name = data["default_linux_server_example_key_name"]
sg_id = data["default_linux_server_example_security_group_ids"][0][0][0]
dns_name = data["default_linux_server_example_private_dns"]
ec2_type = data["default_linux_server_example_instance_type"]


control ' EC2 Exists' do  
  impact 1.0         
  title 'Ec2 instance exists'   
    describe aws_ec2_instance(instance_id) do
      it { should exist }
    end
end

control 'SG Exists' do
  impact 1.0
  title 'check for security groups'
  describe aws_security_group(group_id: sg_id ) do
    it { should exist }
  end
end

control ' Key Exists' do  
  impact 1.0         
  title 'Ec2 instance exists'   
    describe aws_ec2_instance(instance_id) do
      its('key_name') { should eq key_name }
    end
end

control 'EC2 State' do  
  impact 1.0         
  title 'Ec2 instance state should be running'  
    describe aws_ec2_instance(instance_id) do
      its('state') {should eq 'running'}
    end
end

control 'EC2 Type' do  
  impact 1.0         
  title 'Ec2 instance type'  
    describe aws_ec2_instance(instance_id) do
      its('instance_type') { should eq ec2_type }
    end
end
