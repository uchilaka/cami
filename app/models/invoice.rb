# frozen_string_literal: true

class Invoice
  include DocumentRecord

  field :vendor_record_id, type: String
  field :vendor, type: String
  field :status, type: String
  # { email_address }
  field :invoicer, type: Hash
  field :accounts, type: Array
  field :viewed_by_recipient, type: Boolean
  field :invoiced_at, type: Time
  field :due_at, type: Time
  field :currency_code, type: String
  field :amount, type: Hash
  field :due_amount, type: Hash
end
