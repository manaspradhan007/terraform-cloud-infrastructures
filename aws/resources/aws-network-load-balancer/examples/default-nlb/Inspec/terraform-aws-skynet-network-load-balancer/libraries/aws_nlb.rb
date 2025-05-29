require 'aws_backend'

class AwsNlb < AwsResourceBase
    name 'aws_nlb'
    desc 'Verifies settings for an AWS nlb'

    example "
        describe aws_nlb(nlb_name: 'XXXXXX') do
            it { should exist }
        end
    "

    def initialize(opts = {})
        # Call the parent class constructor
        opts = { nlb_name: opts.fetch(:nlb_name),nlb_listener_arn: opts.fetch([:nlb_listener_arn]) } if opts.is_a?(String) # this preserves the original scalar interface
        super(opts)
        

        puts "Start"
        @display_name = opts[:nlb_name]
        if opts[:nlb_name].nil?
            filter = {listener_arns: opts[:nlb_listener_arn]}
            @resp = @aws.nlb_client.describe_listeners(filter)
            @nlb = @resp.listeners[0].default_actions[0].to_h
        else 
            filter = { names: [opts[:nlb_name]]}  
            @resp = @aws.nlb_client.describe_load_balancers(filter)
            @nlb = @resp.load_balancers[0].to_h           
        end

        catch_aws_errors do
            create_resource_methods(@nlb)
        end
    end


    def default?
        @nlb[:is_default]
    end
    def exists?
        !@nlb.empty?
    end 
end