# frozen_string_literal: true

# EasyPostV5 Error object.
class EasyPostV5::Models::Error
  attr_reader :code, :field, :message

  # Initialize a new EasyPostV5 Error
  def initialize(code, field = nil, message = nil)
    @code = code
    @field = field
    @message = message
  end

  # Create an EasyPostV5 Error from an API error response.
  def self.from_api_error_response(data)
    code = data['code']
    field = data['field'] || nil
    message = data['message'] || nil
    EasyPostV5::Models::Error.new(code, field, message)
  end
end
