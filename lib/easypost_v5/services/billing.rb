# frozen_string_literal: true

require 'easypost_v5/constants'

class EasyPostV5::Services::Billing < EasyPostV5::Services::Service
  # Get payment method info (type of the payment method and ID of the payment method)
  def self.get_payment_method_info(priority)
    payment_methods = EasyPostV5::Services::Billing.retrieve_payment_methods
    payment_method_map = {
      'primary' => 'primary_payment_method',
      'secondary' => 'secondary_payment_method',
    }

    payment_method_to_use = payment_method_map[priority]

    error_string = EasyPostV5::Constants::INVALID_PAYMENT_METHOD
    suggestion = "Please use a valid payment method: #{payment_method_map.keys.join(', ')}"
    if payment_methods[payment_method_to_use].nil?
      raise EasyPostV5::Errors::InvalidParameterError.new(
        error_string,
        suggestion,
      )
    end

    payment_method_id = payment_methods[payment_method_to_use]['id']

    unless payment_method_id.nil?
      if payment_method_id.start_with?('card_')
        endpoint = '/v2/credit_cards'
      elsif payment_method_id.start_with?('bank_')
        endpoint = '/v2/bank_accounts'
      else
        raise EasyPostV5::Errors::InvalidObjectError.new(error_string)
      end
    end

    [endpoint, payment_method_id]
  end

  # Fund your EasyPostV5 wallet by charging your primary or secondary card on file.
  def fund_wallet(amount, priority = 'primary')
    payment_info = EasyPostV5::Services::Billing.get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    wrapped_params = { amount: amount }
    @client.make_request(:post, "#{endpoint}/#{payment_id}/charges", EasyPostV5::Models::EasyPostObject, wrapped_params)

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Delete a payment method.
  def delete_payment_method(priority)
    payment_info = EasyPostV5::Services::Billing.get_payment_method_info(priority.downcase)
    endpoint = payment_info[0]
    payment_id = payment_info[1]

    @client.make_request(:delete, "#{endpoint}/#{payment_id}")

    # Return true if succeeds, an error will be thrown if it fails
    true
  end

  # Retrieve all payment methods.
  def retrieve_payment_methods
    response = @client.make_request(:get, '/v2/payment_methods')

    if response['id'].nil?
      raise EasyPostV5::Errors::InvalidObjectError.new(EasyPostV5::Constants::NO_PAYMENT_METHODS)
    end

    response
  end
end
