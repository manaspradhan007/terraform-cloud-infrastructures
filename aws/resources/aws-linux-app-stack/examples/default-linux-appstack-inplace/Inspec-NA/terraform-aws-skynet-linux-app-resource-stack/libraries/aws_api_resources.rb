require 'aws_backend'

class AwsApiResources < AwsResourceBase
  name 'aws_api_resources'
  desc 'Verifies settings for an AWS api gateway'

  example "
    describe aws_api_resources(api_id: 'XXXXXXXX') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { api_id: opts.fetch(:api_id), resource_id: opts.fetch(:resource_id), http_method: opts.fetch(:http_method), stage_name: opts.fetch(:stage_name)} if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:api_id,:resource_id,:http_method,:stage_name])
    @display_name = opts[:api_id]
    if opts[:resource_id].nil? && opts[:http_method].nil? && opts[:stage_name].nil?
        filter = { rest_api_id: opts[:api_id]}
        @resp = @aws.api_client.get_resources(filter)
        @api = @resp.to_h
        @api[:ids] = []
        @api[:path_parts] = []
        @api[:items].each do |item|
          @api[:ids].push item[:id]
          @api[:path_parts].push item[:path_part]
        end

    elsif opts[:stage_name].nil?
        filter = { rest_api_id: opts[:api_id],
                    resource_id: opts[:resource_id],
                    http_method: opts[:http_method] }
        catch_aws_errors do 
          @resp=@aws.api_client.get_method(filter)
          @api = @resp.to_h
        end
    else
        filter={rest_api_id: opts[:api_id],stage_name: opts[:stage_name]}
        @resp=@aws.api_client.get_stage(filter)
        @api = @resp.to_h
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