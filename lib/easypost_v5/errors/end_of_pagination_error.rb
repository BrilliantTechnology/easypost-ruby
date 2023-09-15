# frozen_string_literal: true

class EasyPostV5::Errors::EndOfPaginationError < EasyPostV5::Errors::EasyPostError
  def initialize
    super EasyPostV5::Constants::NO_MORE_PAGES
  end
end
