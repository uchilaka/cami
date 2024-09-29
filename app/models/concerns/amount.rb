# frozen_string_literal: true

class Amount
  include ActiveModel::Model
  include ActiveSupport::NumberHelper

  NON_DECIMAL_DELIMITER_REGEX = /[,\s]/

  attr_accessor :value, :currency_code, :error, :error_value

  def initialize(attributes = {})
    attributes ||= {}
    super(attributes)
    new_currency_code, new_value = attributes.values_at :currency_code, :value
    @value =
      if new_value.blank?
        0.0
      elsif new_value.is_a?(Numeric)
        new_value
      elsif new_value.is_a?(String) && /^[0-9,\s]+(.[0-9]+)?$/.match?(new_value)
        new_value.gsub(NON_DECIMAL_DELIMITER_REGEX, '').to_f
      else
        @error = 'Not a string or number'
        @error_value = new_value
        0.0
      end
    @currency_code = (new_currency_code || 'USD') if @error.nil?
  end

  def to_h
    { value:, currency_code:, error:, error_value: }.compact
  end

  def self.from_json(json)
    new(JSON.parse(json))
  end
end
