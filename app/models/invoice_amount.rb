# frozen_string_literal: true

class InvoiceAmount
  include ActiveSupport::NumberHelper
  include Mongoid::Document

  NON_DECIMAL_DELIMITER_REGEX = /[,\s]/

  field :currency_code, type: String, default: 'USD'
  field :value, type: Float, default: 0.0
  field :error, type: String
  field :error_value, type: String

  validates :currency_code, presence: true, inclusion: { in: %w[USD] }

  def initialize(attributes = {})
    attributes ||= {}
    _currency_code, new_value = attributes.values_at :currency_code, :value
    if new_value.is_a?(Numeric)
      super
    else
      other_attributes = attributes.except(:value)
      super(other_attributes)
      self.value =
        if new_value.blank?
          0.0
        elsif new_value.is_a?(Numeric)
          new_value
        elsif new_value.is_a?(String) && /^[0-9,\s]+(.[0-9]+)?$/.match?(new_value)
          new_value.gsub(NON_DECIMAL_DELIMITER_REGEX, '').to_f
        else
          self.error = 'Not a string or number'
          self.error_value = new_value
          0.0
        end
    end
  end

  def serializable_hash(options = nil)
    extended_options =
      (options || {}).reverse_merge(only: %i[value currency_code error error_value])
    super(extended_options).compact.symbolize_keys
  end

  def to_h
    serializable_hash
  end

  def to_s
    NumberUtils.as_money(value) if value
  end
end
