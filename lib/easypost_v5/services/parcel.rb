# frozen_string_literal: true

class EasyPostV5::Services::Parcel < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::Parcel

  # Create a Parcel object
  def create(params = {})
    wrapped_params = { parcel: params }
    @client.make_request(:post, 'parcels', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Parcel object
  def retrieve(id)
    @client.make_request(:get, "parcels/#{id}", MODEL_CLASS)
  end
end
