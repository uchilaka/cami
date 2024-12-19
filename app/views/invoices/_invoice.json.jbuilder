# frozen_string_literal: true

json.extract! invoice.serializable_hash, :id,
              :payments, :links, :viewed_by_recipient_at, :updated_accounts_at, :invoice_number,
              :status, :issued_at, :due_at, :paid_at, :amount, :due_amount, :currency_code, :notes,
              :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
