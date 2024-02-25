# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  around do |example|
    Sidekiq::Testing.inline! { example.run }
  end

  describe 'callbacks' do
    describe ':after_create_commit' do
      let(:email) { Faker::Internet.email }

      subject do
        Fabricate :user, email:
      end

      it 'initializes a user profile' do
        expect { subject }.to change { UserProfile.count }.by(1)
      end
    end
  end
end
