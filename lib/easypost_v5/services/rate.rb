# frozen_string_literal: true

class EasyPostV5::Services::Rate < EasyPostV5::Services::Service
  # Retrieve a Rate
  def retrieve(id)
    @client.make_request(:get, "rates/#{id}", EasyPostV5::Models::Rate)
  end
end
