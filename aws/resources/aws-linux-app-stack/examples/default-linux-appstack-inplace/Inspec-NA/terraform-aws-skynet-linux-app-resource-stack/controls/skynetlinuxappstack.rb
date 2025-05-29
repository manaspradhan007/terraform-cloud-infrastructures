
# encoding: utf-8
# copyright: 2018, The Authors

title 'MicroService: Linux App Stack'

path = Dir.pwd
info = File.read("#{path}/Data/terraform-aws-linux-app-resource-stack")
data = yaml(content: info).params

sg_id = data["default_linux_appstack_ex_asg_sg_id"]
asg_name = data["default_linux_appstack_ex_autoscaling_group_name"]
lc_name = data["default_linux_appstack_ex_launch_configuration_name"]
codedeploy_name = data["default_linux_appstack_ex_code_deploy_application_name"]

control 'SG Exists' do
    impact 1.0
    title 'check for security groups'
    describe aws_security_group(sg_id) do
      it { should exist }
    end
end

control 'Asg exists' do                        
    impact 1.0                                    
    title 'Asg exists'                            
    describe aws_auto_scaling_group(asg_name) do
      it { should exist }
    end 
  end
  
control 'Launch Config exists' do                         
    impact 1.0                                   
    title 'Lc exists'                           
    describe aws_auto_scaling_group(asg_name) do
      its('launch_configuration_name') { should be_in lc_name }	  
    end 
end

control 'Code Deploy exists' do                       
    impact 1.0                            
    title 'check for existance of bucket'          
    title 'Code Deploy application exists'   
    describe aws_codeDeploy(codedeploy_name) do
      it { should exist }
    end
end