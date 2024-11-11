# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAccountWorkflow, type: :workflow, real_world_data: true do
  let(:user) { Fabricate :user }

  let!(:phone_data) { sample_phone_numbers.sample }
  let!(:current_phone_data) { Phonelib.parse('+2347129218348', 'NG') }
  let!(:account) do
    Fabricate :account,
              metadata: {
                phone: {
                  full_e164: current_phone_data.full_e164,
                  country: 'NG'
                }
              },
              users: [user],
              status: 'guest'
  end

  subject { described_class.call(account:, account_params:, profile_params:) }

  context 'with valid attributes' do
    let(:display_name) { Faker::Company.name }
    let(:email) { Faker::Internet.email }
    let(:slug) { Faker::Internet.slug }
    let(:tax_id) { Faker::Company.swedish_organisation_number }
    let(:phone) { phone_data[:full_e164] }
    let(:metadata) { { 'key' => 'value' } }
    let(:readme) { Faker::Lorem.paragraph }
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

    it 'does NOT an account' do
      expect { subject }.not_to(change { Account.count })
    end

    it { expect(subject.success?).to be(true) }

    context 'and an admin user' do
      pending 'it updates the email address'
    end
  end

  context 'with invalid' do
    pending 'phone number'
    pending 'email'
    pending 'other attributes'
  end
end
