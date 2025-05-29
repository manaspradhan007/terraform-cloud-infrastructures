
path = Dir.pwd
info = File.read("#{path}/terraform-aws-network-load-balancer.yml")
data = yaml(content: info).params

nlb_name = data['default_nlb_example_resource_name_prefix']
dns_name = data['default_nlb_example_nlb_dns']
listener_arn = data['default_nlb_example_listener_arn']
target_group_arn = data['default_nlb_example_target_group_arn']
nlb_state = 'active'


control 'nlb Exists' do  
    impact 1.0         
    title 'nlb should exist'   
    describe aws_nlb(nlb_name: nlb_name ) do
      it { should exist }
    end
end

control 'nlb State' do
    impact 1.0
    title 'nlb State Verification'
    describe aws_nlb(nlb_name: nlb_name) do
        its('state.code') { should eq nlb_state }
    end
end

control 'dns_name Exists' do  
    impact 1.0         
    title 'dns_name should exist'   
    describe aws_nlb(nlb_name: nlb_name ) do
        its('dns_name') { should eq dns_name }
    end
end

control 'nlb_listener Exists' do  
    impact 1.0         
    title 'nlb_listener should exist'   
    describe aws_nlb(nlb_listener_arn: [listener_arn] ) do
      it { should exist }
    end
end

control 'target_group_arn Exists' do  
    impact 1.0         
    title 'target_group_arn should exist'   
    describe aws_nlb(nlb_listener_arn: [listener_arn] ) do
      its('target_group_arn') { should eq target_group_arn }
    end
end



