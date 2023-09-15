# frozen_string_literal: true

class EasyPostV5::Services::CustomsItem < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::CustomsItem

  # Create a CustomsItem object
  def create(params)
    @client.make_request(:post, 'customs_items', MODEL_CLASS, params)
  end

  # Retrieve a CustomsItem object
  def retrieve(id)
    @client.make_request(:get, "customs_items/#{id}", MODEL_CLASS)
  end
end
