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

    it 'returns the account' do
      expect(subject.account).to be_a(Account)
    end

    it 'returns the account with the correct attributes' do
      expect(subject.account.serializable_hash).to \
        match(
          hash_including(
            display_name:,
            slug:,
            tax_id:
            # metadata:
            # email:,
            # phone:,
            # readme:
          )
        )
    end
  end
end
