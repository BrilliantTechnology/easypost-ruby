# frozen_string_literal: true

module EasyPostV5::Errors
end

require_relative 'errors/easy_post_error'
require_relative 'errors/end_of_pagination_error'
require_relative 'errors/api/external_api_error'
require_relative 'errors/filtering_error'
require_relative 'errors/invalid_object_error'
require_relative 'errors/invalid_parameter_error'
require_relative 'errors/missing_parameter_error'
require_relative 'errors/signature_verification_error'
require_relative 'errors/api/api_error'
require_relative 'errors/api/bad_request_error'
require_relative 'errors/api/connection_error'
require_relative 'errors/api/forbidden_error'
require_relative 'errors/api/gateway_timeout_error'
require_relative 'errors/api/internal_server_error'
require_relative 'errors/api/invalid_request_error'
require_relative 'errors/api/method_not_allowed_error'
require_relative 'errors/api/not_found_error'
require_relative 'errors/api/payment_error'
require_relative 'errors/api/proxy_error'
require_relative 'errors/api/rate_limit_error'
require_relative 'errors/api/redirect_error'
require_relative 'errors/api/retry_error'
require_relative 'errors/api/service_unavailable_error'
require_relative 'errors/api/ssl_error'
require_relative 'errors/api/timeout_error'
require_relative 'errors/api/unauthorized_error'
require_relative 'errors/api/unknown_api_error'
