# frozen_string_literal: true

class InvoiceAmount
  include DocumentRecord

  field :currency_code, type: String, default: 'USD'
  field :value, type: Float, default: 0.0
  field :error, type: String
  field :error_value, type: String

  validates :currency_code, presence: true, inclusion: { in: %w[USD] }
end
