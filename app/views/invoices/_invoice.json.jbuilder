json.extract! invoice, :id, :invoiceable_id, :invoiceable_type, :account_id, :user_id, :payments, :links, :viewed_by_recipient_at, :updated_accounts_at, :invoice_number, :status, :issued_at, :due_at, :paid_at, :amount, :due_amount, :currency_code, :notes, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
