# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
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
        Fabricate :user, email:
      end

      it 'initializes a user profile' do
        expect { subject }.to change { UserProfile.count }.by(1)
      end
    end
  end

  describe '#profile' do
    subject { find_or_create_mock_user!(email:) }

    it 'returns the expected user profile' do
      expect(subject.profile).to eq(UserProfile.find_by(user_id: subject.id))
    end
  end
end
