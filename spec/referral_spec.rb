# frozen_string_literal: true

require 'spec_helper'

REFERRAL_CUSTOMER_PROD_API_KEY = ENV['REFERRAL_CUSTOMER_PROD_API_KEY'] || '123'

describe EasyPostV5::Services::ReferralCustomer do
  let(:client) { EasyPostV5::Client.new(api_key: ENV['PARTNER_USER_PROD_API_KEY'] || '123') }

  describe '.create' do
    it 'creates a referral customer' do
      # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
      created_referral_customer = client.referral_customer.create(
        name: 'test user',
        email: 'email@example.com',
        phone: '8888888888',
      )

      expect(created_referral_customer).to be_an_instance_of(EasyPostV5::Models::User)
      expect(created_referral_customer.id).to match('user_')
      expect(created_referral_customer.name).to eq('test user')
    end
  end

  describe '.update_email' do
    it 'updates a referral customer' do
      # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
      referral_customers = client.referral_customer.all(
        page_size: Fixture.page_size,
      )

      updated_user = client.referral_customer.update_email(
        referral_customers.referral_customers[0].id,
        'email2@example.com',
      )

      expect(updated_user).to eq(true)
    end
  end

  describe '.all' do
    # This test requires a partner user's production API key via PARTNER_USER_PROD_API_KEY.
    it 'retrieve all referral customers' do
      referral_customers = client.referral_customer.all(
        page_size: Fixture.page_size,
      )

      referral_customers_array = referral_customers.referral_customers

      expect(referral_customers_array.count).to be <= Fixture.page_size
      expect(referral_customers.has_more).not_to be_nil
      expect(referral_customers_array).to all(be_an_instance_of(EasyPostV5::Models::User))
    end
  end

  describe '.get_next_page' do
    it 'retrieves the next page of a collection' do
      first_page = client.referral_customer.all(
        page_size: Fixture.page_size,
      )

      begin
        next_page = client.referral_customer.get_next_page(first_page)

        first_page_first_id = first_page.referral_customers.first.id
        next_page_first_id = next_page.referral_customers.first.id

        # Did we actually get a new page?
        expect(first_page_first_id).not_to eq(next_page_first_id)
      rescue EasyPostV5::Errors::EndOfPaginationError => e
        # If we get an error, make sure it's because there are no more pages.
        expect(e.message).to eq(EasyPostV5::Constants::NO_MORE_PAGES)
      end
    end
  end

  describe '.add_credit_card' do
    it 'adds a credit card to a referral customer account' do
      # We override the VCR config here since it cannot match the URL due to data scrubbing
      VCR.use_cassette(
        'rewrite/referral/EasyPost_Referral_add_credit_card_adds_a_credit_card_to_a_referral_customer_account',
        match_requests_on: [:method, :uri],
      ) do
        credit_card = client.referral_customer.add_credit_card(
          REFERRAL_CUSTOMER_PROD_API_KEY,
          Fixture.credit_card_details['number'],
          Fixture.credit_card_details['expiration_month'],
          Fixture.credit_card_details['expiration_year'],
          Fixture.credit_card_details['cvc'],
        )

        expect(credit_card.id).to match('card_')
        expect(credit_card.last4).to match('6170')
      end
    end
  end

  it 'raises an error when we cannot send details to Stripe' do
    allow(client.referral_customer).to receive(:create_stripe_token).and_raise(StandardError)
    allow(client.referral_customer).to receive(:retrieve_easypost_stripe_api_key)

    expect {
      client.referral_customer.add_credit_card(
        REFERRAL_CUSTOMER_PROD_API_KEY,
        Fixture.credit_card_details['number'],
        Fixture.credit_card_details['expiration_month'],
        Fixture.credit_card_details['expiration_year'],
        Fixture.credit_card_details['cvc'],
      )
    }.to raise_error(StandardError).with_message('Could not send card details to Stripe, please try again later.')
  end
end
