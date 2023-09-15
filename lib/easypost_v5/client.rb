# frozen_string_literal: true

require_relative 'services'
require_relative 'http_client'
require_relative 'internal_utilities'
require 'json'
require 'securerandom'

class EasyPostV5::Client
  attr_reader :open_timeout, :read_timeout, :api_base

  # Initialize a new Client object
  # @param api_key [String] the API key to be used for requests
  # @param read_timeout [Integer] (60) the number of seconds to wait for a response before timing out
  # @param open_timeout [Integer] (30) the number of seconds to wait for the connection to open before timing out
  # @param api_base [String] ('https://api.easypost.com') the base URL for the API
  # @param custom_client_exec [Proc] (nil) a custom client execution block to be used for requests instead of the default HTTP client (function signature: method, uri, headers, open_timeout, read_timeout, body = nil)
  # @return [EasyPostV5::Client] the client object
  def initialize(api_key:, read_timeout: 60, open_timeout: 30, api_base: 'https://api.easypost.com',
                 custom_client_exec: nil)
    raise EasyPostV5::Errors::MissingParameterError.new('api_key') if api_key.nil?

    @api_key = api_key
    @api_base = api_base
    @api_version = 'v2'
    @read_timeout = read_timeout
    @open_timeout = open_timeout
    @lib_version = File.open(File.expand_path('../../VERSION', __dir__)).read.strip

    # Make an HTTP client once, reuse it for all requests made by this client
    # Configuration is immutable, so this is safe
    @http_client = EasyPostV5::HttpClient.new(api_base, http_config, custom_client_exec)
  end

  SERVICE_CLASSES = [
    EasyPostV5::Services::Address,
    EasyPostV5::Services::ApiKey,
    EasyPostV5::Services::Batch,
    EasyPostV5::Services::BetaRate,
    EasyPostV5::Services::BetaReferralCustomer,
    EasyPostV5::Services::Billing,
    EasyPostV5::Services::CarrierAccount,
    EasyPostV5::Services::CarrierMetadata,
    EasyPostV5::Services::CarrierType,
    EasyPostV5::Services::CustomsInfo,
    EasyPostV5::Services::CustomsItem,
    EasyPostV5::Services::EndShipper,
    EasyPostV5::Services::Event,
    EasyPostV5::Services::Insurance,
    EasyPostV5::Services::Order,
    EasyPostV5::Services::Parcel,
    EasyPostV5::Services::Pickup,
    EasyPostV5::Services::Rate,
    EasyPostV5::Services::ReferralCustomer,
    EasyPostV5::Services::Refund,
    EasyPostV5::Services::Report,
    EasyPostV5::Services::ScanForm,
    EasyPostV5::Services::Shipment,
    EasyPostV5::Services::Tracker,
    EasyPostV5::Services::User,
    EasyPostV5::Services::Webhook,
  ].freeze

  # Loop over the SERVICE_CLASSES to automatically define the method and instance variable instead of manually define it
  SERVICE_CLASSES.each do |cls|
    define_method(EasyPostV5::InternalUtilities.to_snake_case(cls.name.split('::').last)) do
      instance_variable_set("@#{EasyPostV5::InternalUtilities.to_snake_case(cls.name.split('::').last)}", cls.new(self))
    end
  end

  # Make an HTTP request
  #
  # @param method [Symbol] the HTTP Verb (get, method, put, post, etc.)
  # @param endpoint [String] URI path of the resource
  # @param cls [Class] the class to deserialize to
  # @param body [Object] (nil) object to be dumped to JSON
  # @param api_version [String] the version of API to hit
  # @raise [EasyPostV5::Error] if the response has a non-2xx status code
  # @return [Hash] JSON object parsed from the response body
  def make_request(
    method,
    endpoint,
    cls = EasyPostV5::Models::EasyPostObject,
    body = nil,
    api_version = EasyPostV5::InternalUtilities::Constants::API_VERSION
  )
    response = @http_client.request(method, endpoint, nil, body, api_version)

    potential_error = EasyPostV5::Errors::ApiError.handle_api_error(response)
    raise potential_error unless potential_error.nil?

    EasyPostV5::InternalUtilities::Json.convert_json_to_object(response.body, cls)
  end

  # Subscribe a request hook
  #
  # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
  # @param block [Block] a code block that will be executed before a request is made
  # @return [Symbol] the name of the request hook
  def subscribe_request_hook(name = SecureRandom.hex.to_sym, &block)
    EasyPostV5::Hooks.subscribe(:request, name, block)
  end

  # Unsubscribe a request hook
  #
  # @param name [Symbol] the name of the hook
  # @return [Block] the hook code block
  def unsubscribe_request_hook(name)
    EasyPostV5::Hooks.unsubscribe(:request, name)
  end

  # Unsubscribe all request hooks
  #
  # @return [Hash] a hash containing all request hook subscriptions
  def unsubscribe_all_request_hooks
    EasyPostV5::Hooks.unsubscribe_all(:request)
  end

  # Subscribe a response hook
  #
  # @param name [Symbol] the name of the hook. Defaults ot a ranom hexadecimal-based symbol
  # @param block [Block] a code block that will be executed upon receiving the response from a request
  # @return [Symbol] the name of the response hook
  def subscribe_response_hook(name = SecureRandom.hex.to_sym, &block)
    EasyPostV5::Hooks.subscribe(:response, name, block)
  end

  # Unsubscribe a response hook
  #
  # @param name [Symbol] the name of the hook
  # @return [Block] the hook code block
  def unsubscribe_response_hook(name)
    EasyPostV5::Hooks.unsubscribe(:response, name)
  end

  # Unsubscribe all response hooks
  #
  # @return [Hash] a hash containing all response hook subscriptions
  def unsubscribe_all_response_hooks
    EasyPostV5::Hooks.unsubscribe_all(:response)
  end

  private

  def http_config
    http_config = {
      read_timeout: @read_timeout,
      open_timeout: @open_timeout,
      headers: default_headers,
    }

    http_config[:min_version] = OpenSSL::SSL::TLS1_2_VERSION
    http_config
  end

  def default_headers
    {
      'Content-Type' => 'application/json',
      'User-Agent' => user_agent,
      'Authorization' => authorization,
    }
  end

  def user_agent
    ruby_version = EasyPostV5::InternalUtilities::System.ruby_version
    ruby_patchlevel = EasyPostV5::InternalUtilities::System.ruby_patchlevel

    "EasyPostV5/#{@api_version} " \
      "RubyClient/#{@lib_version} " \
      "Ruby/#{ruby_version}-p#{ruby_patchlevel} " \
      "OS/#{EasyPostV5::InternalUtilities::System.os_name} " \
      "OSVersion/#{EasyPostV5::InternalUtilities::System.os_version} " \
      "OSArch/#{EasyPostV5::InternalUtilities::System.os_arch}"
  end

  def authorization
    "Bearer #{@api_key}"
  end
end
