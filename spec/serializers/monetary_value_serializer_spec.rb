# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonetaryValueSerializer do
  let(:invoiceable) { Fabricate :account }
  let(:invoice) { Fabricate(:invoice, invoiceable:, amount: 149.99, status: 'sent') }

  subject { described_class.new(invoice.amount).serializable_hash }

  describe '#value' do
    it { expect(subject[:value]).to eq(149.99) }
  end

  describe '#formatted_value' do
    it { expect(subject[:formatted_value]).to eq('$149.99') }
  end

  describe '#value_in_cents' do
    it { expect(subject[:value_in_cents]).to eq(149_99) }
  end

  describe '#currency_code' do
    it { expect(subject[:currency_code]).to eq('USD') }
  end
end
