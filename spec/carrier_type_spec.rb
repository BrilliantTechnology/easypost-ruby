# frozen_string_literal: true

require 'spec_helper'

describe EasyPostV5::Services::CarrierType do
  let(:client) { EasyPostV5::Client.new(api_key: ENV['EASYPOST_PROD_API_KEY']) }

  describe '.all' do
    it 'retrieves all carrier types' do
      carrier_types = client.carrier_type.all

      expect(carrier_types).to all(be_an_instance_of(EasyPostV5::Models::CarrierType))
    end
  end
end
