# frozen_string_literal: true

class EasyPostV5::Services::CarrierType < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::CarrierType

  # Retrieve all carrier types
  def all
    @client.make_request(:get, 'carrier_types', MODEL_CLASS)
  end
end
