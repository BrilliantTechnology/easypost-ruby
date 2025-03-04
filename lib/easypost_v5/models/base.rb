# frozen_string_literal: true

require 'json'

# The base class for all JSON objects in the library.
class EasyPostV5::Models::Object
  def initialize(data)
    @values = data
    add_properties(data)
  end

  # Convert to a string.
  def to_s(*_args)
    JSON.dump(@values)
  end

  # Convert object to hash
  def to_hash
    JSON.parse(JSON.dump(@values))
  end

  # Get element of an array.
  def [](key)
    @values[key.to_s]
  end

  # Set the element of an array.
  def []=(key, value)
    send(:"#{key}=", value)
  end

  private

  def add_properties(values)
    values.each do |key, _|
      define_singleton_method(key) { handle_value(@values[key]) } # getter
      define_singleton_method("#{key}=") { |v| @values[key] = handle_value(v) } # setter
    end
  end

  def handle_value(val)
    case val
    when Hash
      type = EasyPostV5::InternalUtilities::StaticMapper::BY_TYPE[val['object']] if val['object']
      prefix = EasyPostV5::InternalUtilities::StaticMapper::BY_PREFIX[val['id'].split('_').first] if val['id']
      cls = type || prefix || EasyPostV5::Models::EasyPostObject
      cls.new(val)
    when Array
      val.map { |item| handle_value(item) }
    else
      val
    end
  end
end

# The base class for all API objects in the library that have an ID (plus optional timestamps).
class EasyPostV5::Models::EasyPostObject < EasyPostV5::Models::Object
end
