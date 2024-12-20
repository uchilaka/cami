# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportAccountWorkflow do
  let(:email) { Faker::Internet.email }
  let(:invoice_account) { invoice.accounts.find_by(email:, type: 'Business') }

  let!(:invoice) do
    Fabricate :invoice,
              accounts: [
                {
                  display_name: Faker::Company.name,
                  type: 'Business',
                  email:
                }
              ]
  end

  context 'with missing invoice record' do
    before { invoice.record.destroy }

    subject { described_class.call(invoice_account:) }

    it 'fails with the expected error message' do
      result = subject
      expect(result.success?).to be(false)
      expect(result.errors).to include('Record reference for invoice is missing')
    end
  end

  context 'with no matching accounts' do
    let(:account_profile) { Metadata::Business.find_by(email:) }
    let(:account) { account_profile.business }

    subject { described_class.call(invoice_account:) }

    pending 'logs the account creation'

    it 'creates the expected new account' do
      expect { subject }.to change(Account, :count).by(1)
      expect(subject.account).to eq(account)
    end

    it 'creates the expected new business profile' do
      expect { subject }.to change(Metadata::Business, :count).by(1)
    end

    it 'adds the customer role to the invoice' do
      expect(subject.success?).to be(true)
      expect(account.has_role?(:customer, invoice.record)).to be(true)
    end

    it 'adds the contact role to the invoice' do
      expect(subject.success?).to be(true)
      expect(account.has_role?(:contact, invoice.record)).to be(true)
    end

    context 'without an email address' do
      let(:email) { nil }

      it 'creates the expected new business profile' do
        expect { subject }.to change(Metadata::Business, :count).by(1)
      end

      it 'adds the customer role to the invoice' do
        expect(subject.success?).to be(true)
        expect(account.has_role?(:customer, invoice.record)).to be(true)
      end

      it 'does NOT add the contact role to the invoice' do
        expect(subject.success?).to be(true)
        expect(account.has_role?(:contact, invoice.record)).to be(false)
      end
    end
  end

  pending 'with a matching account'

  pending 'with several matching accounts'
end
