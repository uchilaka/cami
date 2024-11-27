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
#  invoicer                  :jsonb
#  issued_at                 :datetime
#  links                     :jsonb
#  notes                     :text
#  paid_at                   :datetime
#  payment_vendor            :string
#  payments                  :jsonb
#  status                    :integer
#  type                      :string           default("Invoice")
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
require 'rails_helper'

RSpec.describe InvoiceSerializer do
  context 'with a simple invoice' do
    let(:invoiceable) { Fabricate :account }
    let(:invoice) { Fabricate(:invoice, invoiceable:) }

    subject { described_class.new(invoice).serializable_hash }

    it 'serializes the invoice' do
      expect(subject).to match(
        id: invoice.id.to_s,
        invoice_number: invoice.invoice_number,
        invoicer: invoice.invoicer,
        accounts: invoice.accounts,
        amount: invoice.amount,
        currency_code: invoice.currency_code,
        due_amount: invoice.due_amount,
        payment_vendor: invoice.payment_vendor,
        invoiced_at: invoice.invoiced_at,
        due_at: invoice.due_at,
        links: [],
        status: 'SENT',
        viewed_by_recipient: false,
        vendor_record_id: invoice.vendor_record_id,
        vendor_recurring_group_id: invoice.vendor_recurring_group_id
      )
    end
  end
end
