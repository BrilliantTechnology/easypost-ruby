# frozen_string_literal: true

# The workhorse of the EasyPostV5 API, a Shipment is made up of a "to" and "from" Address, the Parcel
# being shipped, and any customs forms required for international deliveries.
class EasyPostV5::Models::Shipment < EasyPostV5::Models::EasyPostObject
  # Get the lowest rate of a Shipment (can exclude by having `'!'` as the first element of your optional filter lists).
  def lowest_rate(carriers = [], services = [])
    EasyPostV5::Util.get_lowest_object_rate(self, carriers, services)
  end
end
