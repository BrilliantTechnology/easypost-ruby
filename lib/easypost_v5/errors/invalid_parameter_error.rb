# frozen_string_literal: true

require 'easypost_v5/constants'

class EasyPostV5::Errors::InvalidParameterError < EasyPostV5::Errors::EasyPostError
  # @param [String] parameter The name of the parameter that was invalid.
  # @param [String] suggestion Optional suggestion message for a valid parameter.
  def initialize(parameter, suggestion = nil)
    super EasyPostV5::Constants::INVALID_PARAMETER % parameter + (suggestion.nil? ? '' : " #{suggestion}")
  end
end
