require 'aws_backend'

class AwsApiInvokeTest < AwsResourceBase
  name 'aws_api_invoke_test'
  desc 'Verifies settings for an AWS api gateway'

  example "
    describe aws_api_invoke_test(api_id: 'XXXXXXXX') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { api_id: opts.fetch(:api_id), resource_id: opts.fetch(:resource_id), http_method: opts.fetch(:http_method), path: opts.fetch(:path), body: opts.fetch(:body)} if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:api_id,:resource_id,:http_method,:path,:body])
    @display_name = opts[:api_id]
    if opts[:api_id].nil?
        @display_name='default'
    else
        filter = { rest_api_id: opts[:api_id],
        resource_id: opts[:resource_id],
        http_method: opts[:http_method], 
        path_with_query_string: opts[:path],
        body: opts[:body]}
    end

    catch_aws_errors do 
        @resp=@aws.api_client.test_invoke_method(filter)
        @api = @resp.to_h
        puts "response"
        puts "Status Code is #{@api[:status]}"
        puts @api[:body]
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