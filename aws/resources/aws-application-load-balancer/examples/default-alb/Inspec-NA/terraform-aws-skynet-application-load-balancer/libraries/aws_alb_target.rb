# frozen_string_literal: true

require 'aws_backend'

class AwsALBTarget < AwsResourceBase
  name 'aws_alb_target'
  desc 'Verifies settings for an AWS ALB'

  example "
    describe aws_alb_target(load_balancer_arn: '') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    # Call the parent class constructor
    opts = { load_balancer_arn: opts } if opts.is_a?(String) # this preserves the original scalar interface
    super(opts)
    validate_parameters([:load_balancer_arn])
    puts "Start TG"
    @display_name = opts[:load_balancer_arn]
    if opts[:load_balancer_arn].nil?
      filter = { name: 'isDefault', values: ['true'] }
      @display_name = 'default'
    else
      #raise ArgumentError, 'aws_alb_target load_balancer_arn must be in the format "arn:" '
      filter = { load_balancer_arn: opts[:load_balancer_arn]}
    end

    catch_aws_errors do
      @resp = @aws.nlb_client.describe_target_groups(filter)
      @alb = @resp.to_h
      @alb[:target_group_arns] = []
      @alb[:target_groups].each do |target_group|
        @alb[:target_group_arns].push(target_group[:target_group_arn])
      end
      create_resource_methods(@alb)
    end
  end

  def default?
    @alb[:is_default]
  end
  def exists?
    !@alb.empty?
  end
  def to_s
    opts.key?(:aws_region) ? "AWS ALB #{@display_name} in #{opts[:aws_region]}" : "AWS ALB #{@display_name}"
  end
end