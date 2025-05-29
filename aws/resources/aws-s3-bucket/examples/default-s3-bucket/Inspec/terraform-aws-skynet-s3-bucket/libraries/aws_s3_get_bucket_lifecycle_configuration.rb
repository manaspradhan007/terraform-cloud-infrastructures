# frozen_string_literal: true

require 'aws_backend'

class AwsS3Bucket < AwsResourceBase
  name 'aws_s3_get_bucket_lifecycle_configuration'
  desc 'Verifies settings for a s3 bucket lifecycle configuration'
  example "
    describe aws_s3_get_bucket_lifecycle_configuration(bucket_name: 'test_bucket') do
      it { should exist }
    end
  "

  def initialize(opts = {})
    opts = { bucket_name: opts } if opts.is_a?(String)
    super(opts)
    @bucket_name = opts[:bucket_name]
    filter = { bucket: opts[:bucket_name]}

    catch_aws_errors do
      begin
       puts filter
       resp = @aws.storage_client.get_bucket_lifecycle_configuration(filter)
       puts resp
       @s3_lifecycle_configs = resp.to_h
        puts "response"
        puts @s3_lifecycle_configs
        create_resource_methods(@s3_lifecycle_configs)
      end
    end
  end

  def exists?
    !@region.nil?
  end

  def to_s
    "S3 Bucket #{@bucket_name}"
  end

  def expiration_days
   return nil unless @s3_lifecycle_configs[:rules]
   return nil unless @s3_lifecycle_configs[:rules][0][:expiration].include?(:days)
   @s3_lifecycle_configs[:rules][0][:expiration][:days]
  end

  def abort_incomplete_multipart_expiration_days
    return nil unless @s3_lifecycle_configs[:rules]
    return nil unless @s3_lifecycle_configs[:rules][0][:abort_incomplete_multipart_upload].include?(:days_after_initiation)
    @s3_lifecycle_configs[:rules][0][:abort_incomplete_multipart_upload][:days_after_initiation]
  end

  def noncurrent_version_expiration_days
    return nil unless @s3_lifecycle_configs[:rules]
    return nil unless @s3_lifecycle_configs[:rules][0][:noncurrent_version_expiration].include?(:noncurrent_days)
    @s3_lifecycle_configs[:rules][0][:noncurrent_version_expiration][:noncurrent_days]
  end

  def storage_class
    return nil unless @s3_lifecycle_configs[:rules]
    return nil unless @s3_lifecycle_configs[:rules][0][:transitions].include?(:storage_class)
    @s3_lifecycle_configs[:rules][0][:transitions][:storage_class]
  end

  def storage_class
    return nil unless @s3_lifecycle_configs[:rules]
    return nil unless @s3_lifecycle_configs[:rules][0][:transitions][0].include?(:storage_class)
    @s3_lifecycle_configs[:rules][0][:transitions][0][:storage_class]
  end

  def transition_days_after_creation
    return nil unless @s3_lifecycle_configs[:rules]
    return nil unless @s3_lifecycle_configs[:rules][0][:transitions][0].include?(:days)
    @s3_lifecycle_configs[:rules][0][:transitions][0][:days]
  end

end