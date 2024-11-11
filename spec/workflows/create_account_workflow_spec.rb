# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccountWorkflow do
  context 'with valid attributes' do
    let(:display_name) { Faker::Company.name }
    let(:email) { Faker::Internet.email }
    let(:slug) { Faker::Internet.slug }
    let(:tax_id) { Faker::Company.swedish_organisation_number }
    let(:phone) { Faker::PhoneNumber.cell_phone_with_country_code }
    let(:metadata) { { 'key' => 'value' } }
    let(:readme) { Faker::Lorem.paragraph }

    let(:params) do
      {
        display_name:,
        email:,
        slug:,
        tax_id:,
        phone:,
        metadata:,
        readme:
      }
    end

    subject { described_class.call(params:) }

    it 'creates an account' do
      expect { subject }.to change { Account.count }.by(1)
    end

    it { is_expected.to be_a_success }

    context 'returns the account' do
      it { expect(subject.account).to be_a(Account) }

      context 'with the correct display_name, slug and tax_id' do
        let(:account_hash) do
          subject
            .account
            .serializable_hash
            .symbolize_keys
            .slice(:display_name, :slug, :tax_id)
        end

        it do
          expect(account_hash).to \
            match(
              hash_including(display_name:, slug:, tax_id:)
            )
        end
      end

      context 'with the right phone number' do
        let(:parsed_number) { Phonelib.parse(phone) }

        it do
          expect(subject.account.metadata.dig('phone', 'full_e164')).to eq(parsed_number.full_e164)
        end
      end

      pending 'with the expected notes'
    end
  end
end
