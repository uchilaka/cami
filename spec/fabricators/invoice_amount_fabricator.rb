# frozen_string_literal: true

Fabricator(:invoice_amount) do
  currency_code { 'USD' }
  value { 0.0 }
end
