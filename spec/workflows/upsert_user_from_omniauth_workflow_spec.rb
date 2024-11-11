# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpsertUserFromOmniauthWorkflow, type: :workflow do
  let(:email) { Faker::Internet.email }
  let(:provider) { 'google' }
  let(:uid) { SecureRandom.alphanumeric(21) }
  let(:access_token) do
    OmniAuth::AuthHash.new(
      provider:,
      uid:,
      info: {
        email:,
        first_name: Faker::Name.neutral_first_name,
        last_name: Faker::Name.last_name,
        image: Faker::Avatar.image,
        unverified_email: email,
        email_verified: false,
        verified: true
      }
    )
  end

  subject { described_class.call(access_token:) }

  pending 'with an unverified email address'

  pending 'with a verified email address'

  context 'when the user already exists' do
    let!(:user) { Fabricate(:user, email:) }

    context 'without a matching identity provider profile' do
      let!(:user) { Fabricate(:user, email:, identity_provider_profiles: []) }

      it do
        expect { subject }.to change { User.count }.by(0).and \
          change { IdentityProviderProfile.count }.by(1)
      end
    end

    context 'with a matching identity provider profile' do
      let(:provider) { 'apple' }

      context 'and the same token uid' do
        let(:uid) { SecureRandom.alphanumeric(21) }

        let!(:user) do
          Fabricate(:user_with_provider_profiles, email:, providers: [provider], uids: { provider => uid })
        end

        it do
          expect { subject }.to change { User.count }.by(0).and \
            change { IdentityProviderProfile.count }.by(0)
        end
      end

      pending 'but a different token uid'
    end
  end

  context 'when the user does not exist' do
    it do
      expect { subject }.to change { User.count }.by(1).and \
        change { IdentityProviderProfile.count }.by(1)
    end
  end

  pending 'when the token is not verified'
end
