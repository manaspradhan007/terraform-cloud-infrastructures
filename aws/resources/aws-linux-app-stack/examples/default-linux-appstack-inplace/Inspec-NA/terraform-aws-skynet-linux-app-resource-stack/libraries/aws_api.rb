require 'aws_backend'

class AwsApi < AwsResourceBase
  name 'aws_api'
  desc 'Verifies settings for an AWS api gateway'

  example "
    describe aws_api(api_id: 'XXXXXXXX') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { api_id: opts.fetch(:api_id), domain_name: opts.fetch(:domain_name) } if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:api_id,:domain_name])
    @display_name = opts[:api_id]
    if opts[:api_id].nil?
      filter = { domain_name: opts[:domain_name]}
      @resp = @aws.api_client.get_domain_name(filter)
      @api = @resp.to_h
    else
      filter = { rest_api_id: opts[:api_id]}
      @resp = @aws.api_client.get_rest_api(filter)
      @api = @resp.to_h
      @api[:end_configuration_type]=@resp.endpoint_configuration.types[0]
    end


    catch_aws_errors do     
      create_resource_methods(@api)
    end
  end

  def default?
    @api[:is_default]
  end
  def exists?
    !@api.nil?
  end
end