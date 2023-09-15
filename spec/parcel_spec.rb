# frozen_string_literal: true

require 'spec_helper'

describe EasyPostV5::Services::Parcel do
  let(:client) { EasyPostV5::Client.new(api_key: ENV['EASYPOST_TEST_API_KEY']) }

  describe '.create' do
    it 'creates a parcel' do
      parcel = client.parcel.create(Fixture.basic_parcel)

      expect(parcel).to be_an_instance_of(EasyPostV5::Models::Parcel)
      expect(parcel.id).to match('prcl_')
      expect(parcel.weight).to eq(15.4)
    end
  end

  describe '.retrieve' do
    it 'retrieves a parcel' do
      parcel = client.parcel.create(Fixture.basic_parcel)
      retrieved_parcel = client.parcel.retrieve(parcel.id)

      expect(retrieved_parcel).to be_an_instance_of(EasyPostV5::Models::Parcel)
      expect(retrieved_parcel.to_s).to eq(parcel.to_s)
    end
  end
end
