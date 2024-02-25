# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  around do |example|
    Sidekiq::Testing.inline! { example.run }
  end

  describe 'callbacks' do
    describe ':after_create_commit' do
      let!(:email) { Faker::Internet.email }

      let(:expected_user) { User.find_by(email:) }
      let(:expected_user_profile) { UserProfile.find_by(user_id: expected_user.id) }

      subject do
        Fabricate :user, email:
      end

      it 'initializes a user profile' do
        expect { subject }.to change { UserProfile.count }.by(1)
        expect(expected_user.profile).to eq(expected_user_profile)
      end
    end
  end
end
