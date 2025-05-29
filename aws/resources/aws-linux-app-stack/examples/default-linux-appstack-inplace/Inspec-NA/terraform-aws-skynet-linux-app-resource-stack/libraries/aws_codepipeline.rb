require 'aws_backend'

class AwsCodepipeline < AwsResourceBase
  name 'aws_codepipeline'
  desc 'Verifies settings for an AWS Codepipeline'

  example "
    describe aws_codepipeline(pipeline_name: 'xxxxxxx') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { pipeline_name: opts } if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:pipeline_name])
    @display_name = opts[:pipeline_name]
    if opts[:pipeline_name].nil?
      filter = { key: 'isDefault', values: ['true'] }
      @display_name = 'default'
    else
      filter = { name: opts[:pipeline_name] }
    end
    catch_aws_errors do
      @resp = @aws.codepipeline_client.get_pipeline(filter)
      @resp_state = @aws.codepipeline_client.get_pipeline_state(filter)
      @codepipeline = @resp.pipeline.to_h
      @codepipeline[:status] = @resp_state.stage_states[0].action_states[0].latest_execution.status
      create_resource_methods(@codepipeline)
    end
  end

  def default?
    @codepipeline[:is_default]
  end

  def exists?
    !@codepipeline.empty?
  end

  def to_s
    opts.key?(:aws_region) ? "Codepipeline #{@display_name} in #{opts[:aws_region]}" : "Codepipeline #{@display_name}"
  end
end