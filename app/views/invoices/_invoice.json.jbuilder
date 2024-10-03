# frozen_string_literal: true

json.ignore_nil!
json.number invoice.invoice_number
json.extract! invoice, :amount, :status, :created_at, :updated_at
json.invoicedAt invoice.invoiced_at&.change(usec: 0)&.iso8601
json.dueAt invoice.due_at&.change(usec: 0)&.iso8601
json.url invoice_url(invoice, format: :json)
