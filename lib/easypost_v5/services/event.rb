# frozen_string_literal: true

require 'json'

class EasyPostV5::Services::Event < EasyPostV5::Services::Service
  MODEL_CLASS = EasyPostV5::Models::Event

  # Retrieve an Event object
  def retrieve(id)
    @client.make_request(:get, "events/#{id}", MODEL_CLASS)
  end

  # Retrieve all Event objects
  def all(params = {})
    @client.make_request(:get, 'events', MODEL_CLASS, params)
  end

  # Retrieve all payloads for an event.
  def retrieve_all_payloads(event_id)
    @client.make_request(:get, "events/#{event_id}/payloads", EasyPostV5::Models::Payload)
  end

  # Retrieve a specific payload for an event.
  def retrieve_payload(event_id, payload_id)
    @client.make_request(:get, "events/#{event_id}/payloads/#{payload_id}", EasyPostV5::Models::Payload)
  end

  # Get the next page of events.
  def get_next_page(collection, page_size = nil)
    get_next_page_helper(collection, collection.events, 'events', MODEL_CLASS, page_size)
  end
end
