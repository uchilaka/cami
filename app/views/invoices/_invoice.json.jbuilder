# frozen_string_literal: true

json.ignore_nil!
# json.key_format! camelize: :lower
# json.deep_format_keys!
json.cache! ['v1', invoice, invoice.updated_at.utc], expires_in: 1.day do
  json.id invoice.id.to_s
  json.vendor_record_id invoice.vendor_record_id
  json.vendor_url nil
  json.number invoice.invoice_number
  json.amount do
    json.value invoice.amount.value
    json.currency_code invoice.currency_code
  end
  json.extract! invoice, :status, :created_at, :updated_at
  json.invoiced_at invoice.invoiced_at&.change(usec: 0)&.iso8601
  json.due_at invoice.due_at&.change(usec: 0)&.iso8601
  json.url invoice_url(invoice, format: :json)
end
