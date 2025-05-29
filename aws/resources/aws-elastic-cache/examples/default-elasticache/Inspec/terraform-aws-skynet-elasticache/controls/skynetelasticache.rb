title 'MicroService: Elasticache Profile 0.12.9'

path = Dir.pwd
info = File.read("#{path}/terraform-aws-elasticache.yml")
data = yaml(content: info).params

cache_sg_id = data['default_elasticache_example_cache_sg_id']
replication_group_id = data['default_elasticache_example_cache_cluster_id']
configuration_endpoint_address_port = data['default_elasticache_example_cache_endpoint']
address_port = configuration_endpoint_address_port.split(':')

control 'Cache SG Exists' do
  impact 1.0
  title 'check for security groups'
  describe aws_security_group(group_id: cache_sg_id) do
    it { should exist }
  end
end

control 'Redis exists' do
  impact 1.0         
  title 'Redis exists'   
  describe aws_redis(replication_group_id: replication_group_id) do
    it { should exist }
  end
end

control 'Redis state' do 
  impact 1.0         
  title 'Redis status is available'   
  describe aws_redis(replication_group_id: replication_group_id) do
    its ('status') { should eq 'available' }
  end
end


control 'Configuration endpoint address' do 
  impact 1.0         
  title 'Configuration endpoint address'   
  describe aws_redis(replication_group_id:replication_group_id) do
    its('configuration_endpoint.address') { should eq address_port[0] }
  end
end

control 'Configuration endpoint port' do 
  impact 1.0         
  title 'Configuration endpoint port'   
  describe aws_redis(replication_group_id:replication_group_id) do
    its('configuration_endpoint.port') { should eq address_port[1].to_i }
  end
end
