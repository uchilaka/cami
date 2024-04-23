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

  def sanitize_hash(hash)
    hash.each do |key, value|
      _old_value = value
      case value
      when Hash
        sanitize_hash(value)
      when String
        hash[key] = replace_pii(key, value)
      when Array
        hash[key] = value.map { |e| sanitize_hash(e) }
      end
    end
    # Return the sanitized hash
    hash
  end

  def replace_pii(label, default_value = nil)
    # Replace PII patterns with corresponding fake data generation
    label.to_s.gsub(/name|email|phone|address|social_security_number|credit_card_number/i) do |match|
      case match
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
end
