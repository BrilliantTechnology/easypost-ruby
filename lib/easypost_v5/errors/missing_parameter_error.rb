# frozen_string_literal: true

require 'easypost_v5/constants'

class EasyPostV5::Errors::MissingParameterError < EasyPostV5::Errors::EasyPostError
  def initialize(parameter)
    super EasyPostV5::Constants::MISSING_REQUIRED_PARAMETER % parameter
  end
end
