# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                        :uuid             not null, primary key
#  amount_cents              :integer          default(0), not null
#  amount_currency           :string           default("USD"), not null
#  due_amount_cents          :integer          default(0), not null
#  due_amount_currency       :string           default("USD"), not null
#  due_at                    :datetime
#  invoice_number            :string
#  invoiceable_type          :string
#  issued_at                 :datetime
#  links                     :jsonb
#  notes                     :text
#  paid_at                   :datetime
#  payment_vendor            :string
#  payments                  :jsonb
#  status                    :integer
#  updated_accounts_at       :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invoiceable_id            :uuid
#  vendor_record_id          :string
#  vendor_recurring_group_id :string
#
# Indexes
#
#  index_invoices_on_invoiceable                          (invoiceable_type,invoiceable_id)
#  index_invoices_on_invoiceable_type_and_invoiceable_id  (invoiceable_type,invoiceable_id)
#
Fabricator(:invoice) do
  payments               { [] }
  links                  { [] }
  updated_accounts_at    '2024-11-11 01:29:44'
  invoice_number         { sequence(:invoice_number) { |n| "INV-#{(n + 1).to_s.rjust(4, '0')}" } }
  status                 1
  issued_at              { Time.zone.now - 7.days }
  due_at                 { Time.zone.now + 23.days }
  paid_at                { Time.zone.now }
  amount_cents           999
  due_amount_cents       999
end
