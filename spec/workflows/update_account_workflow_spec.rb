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
        readme:,
        status: 'active'
      }
    end
    let(:profile_params) do
      { country_alpha2: phone_data[:country] }
    end

    it 'does NOT create an account' do
      expect { subject }.not_to(change { Account.count })
    end

    it 'returns a successful result' do
      expect(subject.success?).to be(true)
    end

    context '#display_name' do
      it do
        expect { subject }.to change { account.reload.display_name }.to(display_name)
      end
    end

    context '#email' do
      it do
        expect { subject }.not_to(change { account.reload.email })
      end
    end

    context '#slug' do
      it do
        expect { subject }.not_to(change { account.reload.slug })
      end
    end

    context '#tax_id' do
      it do
        expect { subject }.to change { account.reload.tax_id }.to(tax_id)
      end
    end

    context '#status' do
      it do
        expect { subject }.to change { account.reload.status }.to('active')
      end
    end

    # TODO: We need to implement an email confirmation workflow to get email addresses
    #   on accounts updated. Ideally, we just have a user serve as a :contact (role)
    #   for the account - since we can confirm users. Business email address are
    #   mostly for record keeping and not for communication (will be cc'd on
    #   all communication with the account).
    pending 'does not update the email address'

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
