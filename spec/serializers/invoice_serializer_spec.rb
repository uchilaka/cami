# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceSerializer do
  context 'with a simple invoice' do
    let(:invoice) { Fabricate(:invoice) }

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
