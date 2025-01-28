# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpsertInvoiceRecordsWorkflow do
  describe '.call' do
    context 'when there are no matching accounts' do
      let(:invoice_accounts) { invoice.metadata['accounts'] }
      let(:individual_account) { invoice_accounts.find { |attr| attr['type'] == 'Individual' } }
      let(:business_account) { invoice_accounts.find { |attr| attr['type'] == 'Business' } }
      let(:invoice) do
        Fabricate(
          :invoice,
          metadata: {
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
          }
        )
      end

      subject { described_class.call(invoice:) }

      it 'creates the expected new accounts' do
        expect { subject }.to change(Account, :count).by(2)
      end

      pending 'logs the account creation'

      pending 'adds the customer role to the invoice'

      context 'for the individual account', skip: 'needs to be refactored' do
        let(:email) { Faker::Internet.email }
        let(:invoice) do
          Fabricate(
            :invoice,
            accounts: [
              # Individual account
              {
                type: 'Individual',
                given_name: Faker::Name.neutral_first_name,
                family_name: Faker::Name.last_name,
                email:
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

        let(:accounts_by_role) { Account.with_role(:contact, invoice.record) }
        let(:account) { accounts_by_role.find_by(type: 'Individual') }
        let(:profile) do
          Metadata::Profile.find_by("vendor_data.#{invoice.payment_vendor}.email": individual_account.email)
        end

        before { subject }

        it 'properly sets the account display name' do
          expect(account.display_name).to eq(individual_account.display_name)
        end

        it 'links the account to the user profile' do
          expect(profile.account).to eq(account)
        end

        it 'properly sets the profile display name' do
          profile_display_name = profile.vendor_data.dig(invoice.payment_vendor.to_sym, :display_name)
          expect(profile_display_name).to eq(individual_account.display_name)
        end
      end

      context 'for the business account' do
        let(:account) { Account.find_by(email: business_account['email']) }

        before { subject }

        it "assigns the 'customer' role to the account", skip: 'TODO: this example is broken, but should be passing' do
          expect(account.has_role?(:customer, invoice)).to be(true)
        end

        it 'properly sets the account display name' do
          expect(account.display_name).to eq(business_account['display_name'])
        end

        it 'updates the invoiceable', skip: 'TODO: this example is broken, but should be passing' do
          expect(invoice.reload.invoiceable).to eq(account)
        end
      end
    end

    context 'with several matching accounts' do
      pending 'creates the expected new accounts'

      pending 'logs the account creation'

      pending 'adds the customer role to the invoice'
    end

    context 'with a matching account' do
      let!(:account) { Fabricate :account, email: Faker::Internet.email }

      let(:metadata) do
        {
          accounts: [
            {
              type: 'Business',
              display_name: Faker::Company.name,
              email: account.email
            }
          ]
        }
      end
      let(:invoice) { Fabricate :invoice, metadata: }
      # let(:matching_invoice_account) do
      #   invoice.metadata['accounts'].find { |attr| attr['email'] == account.email }
      # end

      context 'and account linking turned off (default)' do
        subject { described_class.call(invoice:) }

        it { expect { subject }.to change(Account, :count).by(0) }

        it do
          expect { subject }.not_to(change { invoice.invoiceable })
        end
      end

      context 'and account linking turned on' do
        subject { described_class.call(invoice:, options: { link_accounts: true }) }

        context 'and another invoice account was loaded first' do
          let!(:expected_account_email) { Faker::Internet.email }

          let(:metadata) do
            {
              accounts: [
                {
                  type: 'Individual',
                  given_name: Faker::Name.neutral_first_name,
                  family_name: Faker::Name.last_name,
                  email: expected_account_email
                },
                {
                  type: 'Business',
                  display_name: Faker::Company.name,
                  email: account.email
                }
              ]
            }
          end
          let(:expected_invoiceable) { Account.find_by_email(expected_account_email) }

          it { expect { subject }.to change(Account, :count).by(1) }

          it do
            skip 'TODO: this example is broken, but should be passing'
            expect { subject }.to \
              change { invoice.reload.invoiceable }
                .to(expected_invoiceable)
          end

          it 'adds the customer role to the account on the invoice' do
            expect { subject }.to \
              change { account.has_role?(:customer, invoice) }
                .from(false)
                .to(true)
          end
        end

        context 'and the invoice account is not yet set' do
          it { expect { subject }.to change(Account, :count).by(0) }

          it do
            expect { subject }.to \
              change { invoice.reload.invoiceable }
                .to(account)
          end

          it 'adds the customer role to the account on the invoice' do
            expect { subject }.to \
              change { account.has_role?(:customer, invoice) }
                .from(false)
                .to(true)
          end
        end
      end

      context 'and a matching profile' do
        pending 'with a matching user'
        pending 'without a matching user'
      end

      pending 'and no matching profile'
    end
  end
end
