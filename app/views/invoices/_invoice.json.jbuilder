# frozen_string_literal: true

json.ignore_nil!
json.extract! invoice,
              :id,
              :created_at,
              :updated_at,
              :invoice_number,
              # :due_at,
              # :invoiced_at,
              :amount,
              :status
json.invoicedAt invoice.invoiced_at&.change(usec: 0)&.iso8601
json.dueAt invoice.due_at&.change(usec: 0)&.iso8601
json.url invoice_url(invoice, format: :json)
