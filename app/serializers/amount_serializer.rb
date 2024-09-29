# frozen_string_literal: true

class AmountSerializer < AdhocSerializer
  def attributes
    { value:, currency_code: }
  end

  def value
    NumberUtils.as_money(object['value'])
  end

  def currency_code
    object['currency_code'] || 'USD'
  end
end
