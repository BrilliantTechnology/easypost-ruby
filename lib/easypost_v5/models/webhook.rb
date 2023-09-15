# frozen_string_literal: true

# Each Webhook contains the url which EasyPostV5 will notify whenever an object in our system updates. Several types of objects are processed
# asynchronously in the EasyPostV5 system, so whenever an object updates, an Event is sent via HTTP POST to each configured webhook URL.
class EasyPostV5::Models::Webhook < EasyPostV5::Models::EasyPostObject
end
