# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccountWorkflow, type: :workflow, real_world_data: true do
  let!(:phone_data) { sample_phone_numbers.sample }

  let(:display_name) { Faker::Company.name }
  let(:email) { Faker::Internet.email }
  let(:slug) { Faker::Internet.slug }
  let(:tax_id) { Faker::Company.swedish_organisation_number }
  let(:phone) { phone_data[:full_e164] }
  let(:metadata) { { 'key' => 'value' } }
  let(:readme) { Faker::Lorem.paragraph }
  let(:account_params) { {} }
  let(:profile_params) { {} }

  subject { described_class.call(account_params:, profile_params:) }

  context 'with valid attributes' do
    let(:account_params) do
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
    let(:profile_params) do
      { country_alpha2: phone_data[:country] }
    end

    it 'creates an account' do
      expect { subject }.to change { Account.count }.by(1)
    end

    it { expect(subject.success?).to be(true) }

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
          expect(subject.account.phone['full_e164']).to eq(parsed_number.full_e164)
        end
      end

      context 'with the expected notes' do
        it do
          result = subject
          expect(result.account.readme.to_plain_text).to eq(readme)
        end
      end
    end
  end

  context 'with invalid' do
    describe 'phone_number' do
      let(:phone) { '12345' }
      let(:account_params) do
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
      let(:profile_params) do
        { country_alpha2: phone_data[:country] }
      end

      it 'reports the error on the account' do
        result = subject
        expect(result.account.errors[:phone]).to include('is invalid')
      end

      it 'fails the workflow' do
        result = subject
        expect(result.success?).to be(false)
      end

      it 'reports the expected error' do
        result = subject
        expect(result.messages).to include("Value '#{phone}' is not a valid phone number")
      end
    end

    pending 'phone number'
    pending 'email'
    pending 'other attributes'
  end
end
