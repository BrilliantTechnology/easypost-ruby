# frozen_string_literal: true

require 'spec_helper'

describe EasyPostV5::Services::Rate do
  let(:client) { EasyPostV5::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.retrieve' do
    it 'retrieves a rate' do
      shipment = client.shipment.create(Fixture.basic_shipment)

      rate = client.rate.retrieve(shipment.rates[0].id)

      expect(rate).to be_an_instance_of(EasyPostV5::Models::Rate)
      expect(rate.id).to match('rate')
    end
  end
end
