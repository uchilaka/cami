# frozen_string_literal: true

class InvoiceSerializer < ActiveModel::Serializer
  attributes :vendor_record_id,
             :vendor_recurring_group_id,
             :invoice_number,
             :status,
             :invoicer,
             :accounts,
             :viewed_by_recipient,
             :invoiced_at,
             :due_at,
             :currency_code,
             :amount,
             :due_amount,
             :payments,
             :note,
             :links
end
