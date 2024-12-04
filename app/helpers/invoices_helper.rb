# frozen_string_literal: true

module InvoicesHelper
  def currency_code_options
    Money::Currency.all.map { |code| [code.name, code.iso_code] }
  end
end
