# frozen_string_literal: true

class Amount
  include ActiveModel::Model
  include ActiveSupport::NumberHelper

  attr_accessor :value, :currency_code

  def initialize(attributes = {})
    attributes ||= {}
    @currency_code = attributes[:currency_code] || 'USD'
    # TODO: Parse into a decimal string ready for calculations
    @value = attributes[:value]
  end

  def to_h
    { value:, currency_code: }
  end

  def self.from_json(json)
    new(JSON.parse(json))
  end
end
