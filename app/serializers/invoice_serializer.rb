# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                  :uuid             not null, primary key
#  amount_cents        :integer          default(0), not null
#  amount_currency     :string           default("USD"), not null
#  due_amount_cents    :integer          default(0), not null
#  due_amount_currency :string           default("USD"), not null
#  due_at              :datetime
#  invoice_number      :string
#  invoiceable_type    :string
#  issued_at           :datetime
#  links               :jsonb
#  notes               :text
#  paid_at             :datetime
#  payments            :jsonb
#  status              :integer
#  updated_accounts_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  invoiceable_id      :uuid
#
# Indexes
#
#  index_invoices_on_invoiceable                          (invoiceable_type,invoiceable_id)
#  index_invoices_on_invoiceable_type_and_invoiceable_id  (invoiceable_type,invoiceable_id)
#
class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :invoiceable_id, :invoiceable_type, :payments, :links, :viewed_by_recipient_at, :updated_accounts_at,
             :invoice_number, :status, :issued_at, :due_at, :paid_at, :amount, :due_amount, :currency_code, :notes
  has_one :account
  has_one :user
end
