# frozen_string_literal: true

require 'aws-sdk-autoscaling'
require 'aws-sdk-cloudtrail'
require 'aws-sdk-cloudwatch'
require 'aws-sdk-cloudwatchlogs'
require 'aws-sdk-codepipeline'
require 'aws-sdk-configservice'
require 'aws-sdk-core'
require 'aws-sdk-ec2'
require 'aws-sdk-ecs'
require 'aws-sdk-eks'
require 'aws-sdk-elasticloadbalancing'
require 'aws-sdk-iam'
require 'aws-sdk-kms'
require 'aws-sdk-organizations'
require 'aws-sdk-rds'
require 'aws-sdk-s3'
require 'aws-sdk-sns'
require 'aws-sdk-sqs'
#require 'aws-sdk-secretsmanager'
require 'rspec/expectations'

# AWS Inspec Backend Classes
#
# Class to manage the AWS connection, instantiates all required clients for inspec resources
#
class AwsConnection
  def initialize(params)
    params = {} if params.nil?
    # Special case for AWS, let's allow all resources to specify parameters that propagate to the client init
    # This can be useful for e.g.
    #  https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/stubbing.html
    #  https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html#aws-ruby-sdk-setting-non-standard-endpoint
    if params.is_a?(Hash)
      @client_args = params.fetch(:client_args, nil)
    end
    @cache = {}
  end

  def aws_client(klass)
    # TODO: make this a dict with keys of klass.to_s.to_sym such that we can send different args per client in cases such as EC2 instance that use multiple different clients
    return @cache[klass.to_s.to_sym] ||= klass.new(@client_args) if @client_args
    @cache[klass.to_s.to_sym] ||= klass.new
  end

  def aws_resource(klass, args)
    return klass.new(args, @client_args) if @client_args
    klass.new(args)
  end

  def unique_identifier
    # use aws account id
    client = aws_client(::Aws::STS::Client)
    client.get_caller_identity.account
  end

  # SDK Client convenience methods

  def cloudtrail_client
    aws_client(Aws::CloudTrail::Client)
  end

  def cloudwatch_client
    aws_client(Aws::CloudWatch::Client)
  end

  def cloudwatchlogs_client
    aws_client(Aws::CloudWatchLogs::Client)
  end

  def compute_client
    aws_client(Aws::EC2::Client)
  end

  def config_client
    aws_client(Aws::ConfigService::Client)
  end

  def ecs_client
    aws_client(Aws::ECS::Client)
  end

  def eks_client
    aws_client(Aws::EKS::Client)
  end

  def elb_client
    aws_client(Aws::ElasticLoadBalancing::Client)
  end

  def iam_client
    aws_client(Aws::IAM::Client)
  end

  def kms_client
    aws_client(Aws::KMS::Client)
  end

  def org_client
    aws_client(Aws::Organizations::Client)
  end

  def rds_client
    aws_client(Aws::RDS::Client)
  end

  def service_client
    aws_client(Aws::AutoScaling::Client)
  end

  def sqs_client
    aws_client(Aws::SQS::Client)
  end

  def sns_client
    aws_client(Aws::SNS::Client)
  end

  def storage_client
    aws_client(Aws::S3::Client)
  end

  def sts_client
    aws_client(Aws::STS::Client)
  end

  # def secretsmanager_client
  #   aws_client(Aws::SecretsManager::Client)
  # end


end

# Base class for AWS resources
#
class AwsResourceBase < Inspec.resource(1)
  attr_reader :opts, :aws

  def initialize(opts)
    @opts = opts
    # ensure we have a AWS connection, resources can choose which of the clients to instantiate
    client_args = { client_args: {} }
    if opts.is_a?(Hash)
      # below allows each resource to optionally and conveniently set a region
      client_args[:client_args][:region] = opts[:aws_region] if opts[:aws_region]
      # below allows each resource to optionally and conveniently set an endpoint
      client_args[:client_args][:endpoint] = opts[:aws_endpoint] if opts[:aws_endpoint]
      # this catches the stub_data true option for unit testing - and others that could be useful for consumers
      client_args[:client_args].update(opts[:client_args]) if opts[:client_args]
    end
    @aws = AwsConnection.new(client_args)
    # N.B. if/when we migrate AwsConnection to train, can update above and inject args via:
    # inspec.backend.aws_client(Aws::EC2::Resource,opts)
    # inspec.backend.aws_resource(Aws::EC2::Resource,opts)
    # However, for the unit testing case, would potentially have to instantiate the client ourselves...

    # here we might want to inject stub data for testing, let's use an option for that
    return if !defined?(@opts.keys) || !@opts.include?(:stub_data)
    raise ArgumentError, 'Expected stub data to be an array' if !opts[:stub_data].is_a?(Array)
    opts[:stub_data].each do |stub|
      raise ArgumentError, 'Expect each stub_data hash to have :client, :method and :data keys' if !stub.keys.all? { |a| %i(method data client).include?(a) }
      @aws.aws_client(stub[:client]).stub_responses(stub[:method], stub[:data])
    end
  end

  def validate_parameters(allowed_list)
    allowed_list += %i(client_args stub_data aws_region aws_endpoint)
    raise ArgumentError, 'Scalar arguments not supported' if !defined?(@opts.keys)
    raise ArgumentError, 'Unexpected arguments found' if !@opts.keys.all? { |a| allowed_list.include?(a) }
    raise ArgumentError, 'Provided parameter should not be empty' if !@opts.values.all? { |a| !a.empty? }
    true
  end

  def failed_resource?
    @failed_resource
  end

  # Intercept AWS exceptions
  def catch_aws_errors
    yield # Catch and create custom messages as needed
  rescue Aws::Errors::MissingCredentialsError
    Inspec::Log.error 'It appears that you have not set your AWS credentials. See https://www.inspec.io/docs/reference/platforms for details.'
    fail_resource('No AWS credentials available')
  rescue Aws::Errors::ServiceError => e
    if is_permissions_error(e)
      advice = ''
      error_type = e.class.to_s.split('::').last
      if error_type == 'InvalidAccessKeyId'
        advice = 'Please ensure your AWS Access Key ID is set correctly.'
      elsif error_type == 'AccessDenied'
        advice = 'Please check the IAM permissions required for this Resource in the documentation, ' \
                 'and ensure your Service Principal has these permissions set.'
      end
      fail_resource("Unable to execute control: #{e.message}\n#{advice}")
    else
      Inspec::Log.warn "AWS Service Error encountered running a control with Resource #{@__resource_name__}. " \
                       "Error message: #{e.message}. You should address this error to ensure your controls are " \
                       'behaving as expected.'
      @failed_resource = true
      nil
    end
  end

  def create_resource_methods(object)
    dm = AwsResourceDynamicMethods.new
    dm.create_methods(self, object)
  end

  # Each client has its own variation of Aws::*::Errors::AccessDenied, making the checking cumbersome and flaky.
  # Checking the status code is more reliable.
  def is_permissions_error(error)
    true if error.context.http_response.status_code == 403
  end

  def map_tags(tag_list)
    return {} if tag_list.nil? || tag_list.empty?
    tags = {}
    tag_list.each do |tag|
      tags[tag[:key]] = tag[:value]
    end
    tags
  end
end

# Class to create methods on the calling object at run time.  Heavily based on the Azure Inspec resources.
#
class AwsResourceDynamicMethods
  # Given the calling object and its data, create the methods on the object according
  # to the data that has been retrieved. Various types of data can be returned so the method
  # checks the type to ensure that the necessary methods are configured correctly
  #
  # @param object The object on which the methods should be created
  # @param data The data from which the methods should be created
  def create_methods(object, data)
    # Check the type of data as this affects the setup of the methods
    # If it is an Aws Generic Resource then setup methods for each of
    # the instance variables
    case data.class.to_s
    when /Aws::.*/
      # iterate around the instance variables
      data.instance_variables.each do |var|
        create_method(object, var.to_s.delete('@'), data.instance_variable_get(var))
      end
      # When the data is a Hash object iterate around each of the key value pairs and
      # craete a method for each one.
    when 'Hash'
      data.each do |key, value|
        create_method(object, key, value)
      end
    end
  end

  private

  # Method that is responsible for creating the method on the calling object. This is
  # because some nesting maybe required. For example of the value is a Hash then it will
  # need to have an AwsResourceProbe create for each key, whereas if it is a simple
  # string then the value just needs to be returned
  #
  def create_method(object, name, value)
    # Create the necessary method based on the var that has been passed
    # Test the value for its type so that the method can be setup correctly
    case value.class.to_s
    when 'String', 'Integer', 'TrueClass', 'FalseClass', 'Fixnum'
      object.define_singleton_method name do
        value
      end
    when 'Hash'
      value.count.zero? ? return_value = value : return_value = AwsResourceProbe.new(value)
      object.define_singleton_method name do
        return_value
      end
      # there are nested AWS API classes throughout
    when /Aws::.*/
      object.define_singleton_method name do
        value = value.to_h if value.respond_to? :to_h
        AwsResourceProbe.new(value)
      end
    when 'Array'
      # Some things are just string or integer arrays
      # Check this by seeing if the first element is a string / integer / boolean or
      # a hashtable
      # This may not be the best method, but short of testing all elements in the array, this is
      # the quickest test
      # p value[0].class.to_s
      case value[0].class.to_s
      when 'String', 'Integer', 'TrueClass', 'FalseClass', 'Fixnum'
        probes = value
      else
        if name.eql?(:tags)
          probes = {}
          value.each do |tag|
            probes[tag[:key]] = tag[:value]
          end
        else
          probes = []
          value.each do |value_item|
            value_item = value_item.to_h if value_item.respond_to? :to_h
            probes << AwsResourceProbe.new(value_item)
          end
        end
      end
      object.define_singleton_method name do
        probes
      end
    end
  end
end

# Class object that is created for each element that is returned by GCP.
# This is what is interrogated by InSpec. If they are nested hashes, then this results
# in nested AwsResourceProbe objects.
#
# The methods for each of the classes are dynamically defined at run time and will
# match the items that are retrieved from GCP. See the 'test/integration/verify/controls' for
# examples
#
class AwsResourceProbe
  attr_reader :name, :type, :location, :item, :count

  # Initialize method for the class. Accepts an item, be it a scalar value, hash or GCP object
  # It will then create the necessary dynamic methods so that they can be called in the tests
  # This is accomplished by call the AwsResourceDynamicMethods
  #
  # @param item The item from which the class will be initialized
  #
  # @return AwsResourceProbe
  def initialize(item)
    dm = AwsResourceDynamicMethods.new
    dm.create_methods(self, item)

    # Set the item as a property on the class
    # This is so that it is possible to interrogate what has been added to the class and isolate them from
    # the standard methods that a Ruby class has.
    # This used for checking Tags on a resource for example
    # It also allows direct access if so required
    @item = item

    # Set how many items have been set
    @count = item.length if item.respond_to? :length
  end

  # Allows resources to respond to the include test
  # This means that things like tags can be checked for and then their value tested
  #
  # @param [String] key Name of the item to look for in the @item property
  def include?(key)
    @item.key?(key)
  end
end