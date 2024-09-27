# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceDocumentSerializer, skip_in_ci: true do
  let(:invoice_data) do
    YAML.load_file('spec/fixtures/pii/paypal/fetch_invoices.yml')
  end
  let(:items) { invoice_data['items'] }

  context 'when serializing a collection of invoices' do
    subject { items.map { |data| described_class.new(data) } }

    it 'parses the expected number of invoices' do
      expect(subject.size).to eq 23
    end
  end

  context 'when serializing a single invoice' do
    let(:item) { items.find { |data| data['id'] == 'INV2-JT5J-QZ56-F6TC-QX2E' } }

    subject { described_class.new(item).serializable_hash }

    it '#invoice_number' do
      expect(subject[:invoice_number]).to eq '2018-INV0042'
    end

    it '#vendor_record_id' do
      expect(subject[:vendor_record_id]).to eq 'INV2-JT5J-QZ56-F6TC-QX2E'
    end

    it '#invoicer' do
      expect(subject[:invoicer]).to eq(email_address: 'paypal@larcity.com')
    end

    it '#amount' do
      expect(subject[:amount]).to eq(currency_code: 'USD', value: '394.00')
    end

    it '#due_amount' do
      expect(subject[:due_amount]).to eq(currency_code: 'USD', value: '0.00')
    end

    it '#payment_vendor' do
      expect(subject[:payment_vendor]).to eq 'paypal'
    end

    it '#payments' do
      expect(subject[:payments]).to eq(paid_amount: { currency_code: 'USD', value: '394.00' })
    end

    it '#invoiced_at' do
      expect(subject[:invoiced_at]).to eq '2018-01-12'
    end

    it '#due_at' do
      expect(subject[:due_at]).to eq '2018-01-12'
    end
  end
end
