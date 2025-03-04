# frozen_string_literal: true

# The Pickup object allows you to schedule a pickup from your carrier from your customer's residence or place of business.
class EasyPostV5::Models::Pickup < EasyPostV5::Models::EasyPostObject
  # Get the lowest rate of a Pickup (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPostV5::Util.get_lowest_object_rate(self, carriers, services, 'pickup_rates')
  end
end
