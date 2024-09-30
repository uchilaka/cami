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
      expect(result.message).to eq(I18n.t('models.invoice.errors.record_missing'))
    end
  end

  context 'with no matching accounts' do
    let(:account_profile) { Metadata::Business.find_by(email:) }
    let(:account) { account_profile.business }

    subject { described_class.call(invoice_account:) }

    it 'creates the expected new account' do
      expect { subject }.to change(Account, :count).by(1)
    end

    it 'creates the expected new business profile' do
      expect { subject }.to change(Metadata::Business, :count).by(1)
    end

    it 'adds the customer role to the invoice' do
      expect(account.has_role?(:customer, invoice.record)).to be(true)
    end

    it 'adds the contact role to the invoice' do
      expect(account.has_role?(:contact, invoice.record)).to be(true)
    end

    pending 'logs the account creation'

    context 'without an email address' do
      pending 'does not add the contact role'
    end
  end

  pending 'with a matching account'

  pending 'with several matching accounts'
end
