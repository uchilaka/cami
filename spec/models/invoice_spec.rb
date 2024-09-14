# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context 'when initialized' do
    let(:invoice) { Fabricate :invoice }

    it 'should have an initialized amount' do
      expect(invoice['amount']).to match(currency_code: 'USD', value: 0.0)
    end

    it 'should have a corresponding (relational) record' do
      expect(InvoiceRecord.find(invoice.record_id)).to be_present
    end
  end
end
