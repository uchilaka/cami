# frozen_string_literal: true

class Invoice
  include DocumentRecord
  include Mongoid::Attributes::Dynamic

  field :vendor_record_id, type: String
  field :invoice_number, type: String
  field :vendor, type: String
  field :status, type: String
  # { email_address }
  field :invoicer, type: Hash
  field :accounts, type: Array
  field :viewed_by_recipient, type: Boolean
  field :invoiced_at, type: Time
  field :due_at, type: Time
  field :currency_code, type: String
  # { currency_code, value }
  field :amount, type: Hash
  # { currency_code, value }
  field :due_amount, type: Hash
  # { payments: { paid_amount: { currency_code, value } } }
  field :payments, type: Hash
  field :links, type: Array
end
