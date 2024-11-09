# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  family_name            :string
#  given_name             :string
#  last_request_at        :datetime
#  locked_at              :datetime
#  nickname               :string
#  providers              :string           default([]), is an Array
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  timeout_in             :integer          default(1800)
#  uids                   :jsonb
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  primary_profile_id     :string
#
# Indexes
#
#  index_users_on_confirmation_token         (confirmation_token) UNIQUE
#  index_users_on_email                      (email) UNIQUE
#  index_users_on_id_and_primary_profile_id  (id,primary_profile_id) UNIQUE
#  index_users_on_reset_password_token       (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:email) { Faker::Internet.email }

  around do |example|
    Sidekiq::Testing.inline! { example.run }
  end

  describe 'callbacks' do
    describe ':after_create_commit' do
      subject do
        Fabricate(:user, email:)
      end

      it 'initializes a user profile' do
        expect { subject }.to change { Metadata::Profile.count }.by(1)
      end
    end

    describe ':after_destroy_commit' do
      subject { Fabricate(:user, email:) }

      it 'destroys the user profile' do
        expect(subject.profile.present?).to be(true)
        expect { subject.destroy }.to change { Metadata::Profile.count }.by(-1)
      end
    end
  end

  describe '#profile' do
    # subject { find_or_create_mock_user!(email:) }
    subject { Fabricate(:user, email:) }

    it 'returns the expected user profile' do
      expect(subject.profile).to eq(Metadata::Profile.find_by(user_id: subject.id))
    end

    it 'returns a Metadata::Profile' do
      expect(subject.profile).to be_a(Metadata::Profile)
    end

    it 'is persisted' do
      expect(subject.profile).to be_persisted
    end
  end

  describe '#admin?' do
    subject { Fabricate(:user, email:) }

    context 'when the user has the admin role' do
      before { subject.add_role(:admin) }

      it 'returns true' do
        expect(subject.admin?).to be(true)
      end
    end

    context 'when the user does not have the admin role' do
      it 'returns false' do
        expect(subject.admin?).to be(false)
      end
    end
  end
end
