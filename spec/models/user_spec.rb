# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  family_name            :string
#  given_name             :string
#  nickname               :string
#  providers              :string           default([]), is an Array
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uids                   :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
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
    subject { find_or_create_mock_user!(email:) }

    it 'returns the expected user profile' do
      expect(subject.profile).to eq(Metadata::Profile.find_by(user_id: subject.id))
    end
  end
end
