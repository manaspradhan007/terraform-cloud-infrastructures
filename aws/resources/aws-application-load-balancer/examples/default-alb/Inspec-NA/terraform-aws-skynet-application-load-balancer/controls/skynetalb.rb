# encoding: utf-8
# copyright: 2018, The Authors

title 'MicroService: Application Load Balancer 0.12.9 Upgrade'

path = Dir.pwd
info = File.read("#{path}/terraform-aws-application-load-balancer.yml")
data = yaml(content: info).params

alb_arn = data['default_alb_example_alb_arn']
alb_state = 'active'
alb_target_group = data['default_alb_example_target_group_arn']

control 'ALB Exists' do                   
    impact 1.0                              
    title 'ALB test'            
    describe aws_alb(load_balancer_arn: alb_arn) do
        it { should exist }
    end
end

control 'ALB State' do
    impact 1.0
    title 'ALB State Verification'
    describe aws_alb(load_balancer_arn: alb_arn) do
        its('state.code') { should eq alb_state }
    end
end

control 'ALB Target Group' do
    impact 1.0
    title 'ALB Target Group Verification'
    describe aws_alb_target(load_balancer_arn: alb_arn) do
        its('target_group_arns') { should include alb_target_group }
    end
end


