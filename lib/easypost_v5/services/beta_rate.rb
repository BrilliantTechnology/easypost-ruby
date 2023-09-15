# frozen_string_literal: true

class EasyPostV5::Services::BetaRate < EasyPostV5::Services::Service
  # Retrieve a list of stateless rates.
  def retrieve_stateless_rates(params = {})
    wrapped_params = {
      shipment: params,
    }

    @client.make_request(:post, 'rates', EasyPostV5::Models::Rate, wrapped_params, 'beta').rates
  end
end
