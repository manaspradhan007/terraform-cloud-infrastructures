# frozen_string_literal: true

require 'aws_backend'

class AwscodeDeploy < AwsResourceBase
  name 'aws_codeDeploy'
  desc 'Verifies settings for an AWS codeDeploy'


  def initialize(opts = {})
    # Call the parent class constructor
    opts = { codeDeploy_name: opts } if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:codeDeploy_name])
    puts "Start"
    @display_name = opts[:codeDeploy_name]
    if opts[:codeDeploy_name].nil?
      filter = { name: 'isDefault', values: ['true'] }
      @display_name = 'default'
    else
      raise ArgumentError, 'aws_codeDeploy codeDeploy name must be in the format "Q1-" pre/post-followed by hexadecimal characters.' if opts[:codeDeploy_name] !~ /\D1\w/
      filter = { application_name: opts[:codeDeploy_name]}
    end

    catch_aws_errors do
        @resp = @aws.codeDeploy_client.list_deployment_groups(filter)
        @codeDeploy = @resp.to_h
        create_resource_methods(@codeDeploy)
    end
  end

  def default?
    @codeDeploy[:is_default]
  end

  def exists?
    !@codeDeploy.empty?
  end
end