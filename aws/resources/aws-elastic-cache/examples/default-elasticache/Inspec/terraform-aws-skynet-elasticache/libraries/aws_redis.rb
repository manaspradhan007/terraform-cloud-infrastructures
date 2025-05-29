require 'aws_backend'

class AwsRedis < AwsResourceBase
  name 'aws_redis'
  desc 'Verifies settings for an AWS Redis'

  example "
    describe aws_vpngateway(replication_group_id: 'vgw-12345678') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { replication_group_id: opts } if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:replication_group_id])
    @display_name = opts[:replication_group_id]
    if opts[:replication_group_id].nil?
      filter = { name: 'isDefault', values: ['true'] }
      @display_name = 'default'
    else
      filter = { replication_group_id: opts[:replication_group_id] }
    end

    catch_aws_errors do
      @resp = @aws.ec_client.describe_replication_groups(filter)
      @redis = @resp.replication_groups[0].to_h
      create_resource_methods(@redis)
    end
  end

  def default?
    @redis[:is_default]
  end

  def exists?
    !@redis.nil?
  end

  def available?
    return false unless exists?
    @redis[:status] == 'available'
  end

  def to_s
    opts.key?(:aws_region) ? "Redis #{@display_name} in #{opts[:aws_region]}" : "Redis #{@display_name}"
  end
end