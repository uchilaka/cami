# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:error_amount) do
    {
      value: 0.0,
      error: 'Not a string or number',
      error_value: 'invalid value'
    }
  end

  context 'when initialized' do
    let(:invoice) { described_class.new(payment_vendor: 'paypal') }

    it 'should have an initialized amount' do
      expect { invoice.save }.to change { invoice.amount }.from(nil).to(currency_code: 'USD', value: 0.0)
      expect(invoice).to be_valid
    end
  end

  context 'when persisted' do
    subject { Fabricate(:invoice) }

    it 'should have a corresponding (relational) record' do
      expect(InvoiceRecord.find(subject.record_id)).to be_present
    end
  end

  context '#amount' do
    subject { Fabricate(:invoice, amount: { value: '42.90' }) }

    it 'should save the value as float' do
      expect(subject.amount).to eq(currency_code: 'USD', value: 42.9)
    end
  end

  context '#due_amount' do
    subject { Fabricate(:invoice, due_amount: { value: '5,486.05' }) }

    it 'should save the value as float' do
      expect(subject.due_amount).to eq(currency_code: 'USD', value: 5_486.05)
    end

    context 'with an invalid string value' do
      subject { Fabricate(:invoice, due_amount: { value: 'invalid value' }) }

      it 'should save the expected value' do
        expect(subject.due_amount).to eq(error_amount)
      end
    end
  end

  context '#payments' do
    subject { Fabricate(:invoice, payments: { paid_amount: { value: '1,000.12' } }) }

    it 'should save the value as float' do
      expect(subject.payments).to eq(paid_amount: { currency_code: 'USD', value: 1_000.12 })
    end

    context 'when attribute value is nil' do
      subject { Fabricate(:invoice, payments: nil) }

      it 'should be nil' do
        expect(subject.payments).to be_nil
      end
    end

    context 'with an invalid value' do
      subject { Fabricate(:invoice, payments: { paid_amount: { value: 'invalid value' } }) }

      it 'should save the expected value' do
        expect(subject.payments).to eq(paid_amount: error_amount)
      end
    end
  end
end
