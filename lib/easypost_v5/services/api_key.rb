# frozen_string_literal: true

class EasyPostV5::Services::ApiKey < EasyPostV5::Services::Service
  # Retrieve all api keys.
  def all
    @client.make_request(:get, 'api_keys', EasyPostV5::Models::ApiKey)
  end
end
