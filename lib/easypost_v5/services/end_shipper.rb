# frozen_string_literal: true

class EasyPostV5::Services::EndShipper < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::EndShipper

  # Create an EndShipper object.
  def create(params = {})
    wrapped_params = { address: params }

    @client.make_request(:post, 'end_shippers', MODEL_CLASS, wrapped_params)
  end

  # Retrieve an EndShipper object.
  def retrieve(id)
    @client.make_request(:get, "end_shippers/#{id}", MODEL_CLASS)
  end

  # Retrieve all EndShipper objects.
  def all(params = {})
    @client.make_request(:get, 'end_shippers', MODEL_CLASS, params)
  end

  # Updates an EndShipper object. This requires all parameters to be set.
  def update(id, params)
    wrapped_params = { address: params }

    @client.make_request(:put, "end_shippers/#{id}", MODEL_CLASS, wrapped_params)
  end

  # TODO: Add support for getting the next page of end shippers when the API supports it.
end
