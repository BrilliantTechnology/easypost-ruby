# frozen_string_literal: true

class EasyPostV5::Services::CarrierMetadata < EasyPostV5::Services::Service
  # Retrieve metadata for carrier(s).
  def retrieve(carriers = [], types = [])
    path = '/metadata/carriers?'

    params = {}

    if carriers.length.positive?
      params[:carriers] = carriers.join(',')
    end

    if types.length.positive?
      params[:types] = types.join(',')
    end

    path += URI.encode_www_form(params)

    @client.make_request(:get, path, EasyPostV5::Models::EasyPostObject, params).carriers
  end
end
