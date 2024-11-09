# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountPolicy do
  describe '#accessible_to_user?' do
    let(:account) { Fabricate :account }
    let(:user) { Fabricate :user }

    context 'when user is associated with the account' do
      let(:account) { Fabricate :account, users: [user] }

      it 'returns true' do
        expect(described_class.new(user, account).accessible_to_user?).to be true
      end
    end

    context 'when user is not associated with the account' do
      it 'returns false' do
        expect(described_class.new(user, account).accessible_to_user?).to be false
      end
    end
  end
end
