# frozen_string_literal: true

class EasyPostV5::Errors::EasyPostError < StandardError
  def pretty_print
    message.to_s
  end
end
