# frozen_string_literal: true

class EasyPostV5::Services::Webhook < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::Webhook

  # Create a Webhook.
  def create(params = {})
    wrapped_params = { webhook: params }
    @client.make_request(:post, 'webhooks', MODEL_CLASS, wrapped_params)
  end

  # Retrieve a Webhook
  def retrieve(id)
    @client.make_request(:get, "webhooks/#{id}", MODEL_CLASS)
  end

  # Retrieve a list of Webhooks
  def all(params = {})
    @client.make_request(:get, 'webhooks', MODEL_CLASS, params)
  end

  # Update a Webhook.
  def update(id, params = {})
    @client.make_request(:patch, "webhooks/#{id}", MODEL_CLASS, params)
  end

  # Delete a Webhook.
  def delete(id)
    @client.make_request(:delete, "webhooks/#{id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end
end
