# frozen_string_literal: true

require 'json'

module PIIHelper
  def sanitize_json(data)
    parsed_data =
      if data.is_a?(String)
        JSON.parse(data)
      else
        data
      end
    sanitize_hash(parsed_data)
  end

  def sanitize_hash(hash, debug: false)
    _old_hash = hash.deep_dup if debug
    hash.each do |label, value|
      _old_value = value
      case value
      when Hash
        sanitize_hash(value)
      when String
        hash[label] = replace_pii(value, label:)
      when Array
        hash[label] = value.map { |e| sanitize_hash(e) }
      end
    end
    # Return the sanitized hash
    hash
  end

  def replace_pii(default_value = nil, label:)
    # Replace PII patterns with corresponding fake data generation
    case label
    when /(sur)?name/i, /(business|given|family|full)_name/i
      Faker::Name.neutral_first_name
    when /email/i
      Faker::Internet.email
    when /phone/i
      Faker::PhoneNumber.phone_number
    when /address/i
      Faker::Address.full_address
    when /social_security_number/i
      '***-**-****'
    when /credit_card_number/i
      '****-****-****-****'
    else
      default_value
    end
  end
end
