# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpsertInvoiceRecordsWorkflow do
  describe '.call' do
    context 'when there are no matching accounts' do
      let(:individual_account) { invoice.accounts.find_by(type: 'Individual') }
      let(:business_account) { invoice.accounts.find_by(type: 'Business') }
      let(:invoice) do
        Fabricate(
          :invoice,
          accounts: [
            # Individual account
            {
              type: 'Individual',
              given_name: Faker::Name.neutral_first_name,
              family_name: Faker::Name.last_name,
              email: Faker::Internet.email
            },
            # Business account
            {
              type: 'Business',
              display_name: Faker::Company.name,
              email: Faker::Internet.email
            }
          ]
        )
      end

      # before do
      #   invoice.update(accounts: [individual_account, business_account])
      # end

      subject { described_class.call(invoice:) }

      it 'creates the expected new accounts' do
        expect { subject }.to change(Account, :count).by(2)
      end

      it 'creates the expected new (individual) profile(s)' do
        expect { subject }.to change(Metadata::Profile, :count).by(1)
      end

      pending 'logs the account creation'

      pending 'adds the customer role to the invoice'

      context 'for the individual account' do
        let(:accounts_by_role) { Account.with_role(:contact, invoice.record) }
        let(:account) { accounts_by_role.find_by(type: 'Individual') }
        let(:profile) do
          Metadata::Profile.find_by("vendor_data.#{invoice.payment_vendor}.email": individual_account.email)
        end

        before { subject }

        it 'properly sets the account display name' do
          expect(account.display_name).to eq(individual_account.display_name)
        end

        it 'properly sets the profile display name' do
          profile_display_name = profile.vendor_data.dig(invoice.payment_vendor.to_sym, :display_name)
          expect(profile_display_name).to eq(individual_account.display_name)
        end
      end

      # TODO: Something about assignment of roles to Businesses doesn't
      #   seem to be working right
      xcontext 'for the business account' do
        let(:accounts_by_role) { Business.with_role(:customer, invoice.record) }
        let(:account) { accounts_by_role.find_by(display_name: business_account.display_name) }

        before { subject }

        it 'properly sets the account display name' do
          expect(account).not_to be_nil
        end

        # A business account will have both customer and contact roles
        # with respect to the invoice
        it 'adds the contact role to the invoice' do
          expect(account.has_role?(:contact, invoice.record)).to be(true)
        end
      end
    end

    context 'when there are several matching accounts' do
      pending 'creates the expected new accounts'

      pending 'logs the account creation'

      pending 'adds the customer role to the invoice'
    end

    context 'with a matching account' do
      context 'and a matching profile' do
        pending 'with a matching user'
        pending 'without a matching user'
      end

      pending 'and no matching profile'
    end
  end
end
