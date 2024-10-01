# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:error_amount) { { value: 0.0, currency_code: 'USD', error: 'Not a string or number' } }

  context 'when initialized' do
    let(:invoice) { described_class.new(payment_vendor: 'paypal', amount: {}, due_amount: {}, payments: nil) }

    it 'should have an initialized amount' do
      expect(invoice.amount.value).to eq(0.0)
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
      expect(subject.amount.value).to eq(42.9)
    end
  end

  context '#due_amount' do
    subject { Fabricate(:invoice, due_amount: { value: '5,486.05' }) }

    it 'should save the value as float' do
      expect(subject.due_amount.value).to eq(5_486.05)
    end

    context 'with an invalid string value' do
      subject { Fabricate(:invoice, due_amount: { value: 'invalid value' }) }

      it 'should save the expected value' do
        expect(subject.due_amount.to_h).to eq(error_amount.merge(error_value: 'invalid value'))
      end
    end
  end

  context '#payments' do
    let(:invoice) { Fabricate(:invoice, payments: [{ value: '1,000.12' }]) }

    subject { invoice.payments.map(&:serializable_hash) }

    it 'should save the value as float' do
      expect(subject).to eq([{ currency_code: 'USD', value: 1_000.12 }])
    end

    context 'when attribute value is nil' do
      let(:invoice) { Fabricate(:invoice, payments: nil) }

      it 'should be nil' do
        expect(subject).to eq([])
      end
    end

    context 'with an invalid value' do
      let(:invoice) { Fabricate(:invoice, payments: [{ value: 'invalid value' }]) }

      it 'should save the expected value' do
        expect(subject).to eq([error_amount.merge(error_value: 'invalid value')])
      end
    end
  end
end
