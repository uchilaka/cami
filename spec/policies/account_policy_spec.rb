# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountPolicy, type: :policy do
  let(:user) { Fabricate :user }
  let(:account) { Fabricate :account }
  let(:account_policy) { described_class.new(user, account) }

  describe '#create?' do
    it { expect(account_policy.create?).to be false }
  end

  describe '#accessible_to_user?' do
    it { expect(account_policy.accessible_to_user?).to be false }
  end

  describe AccountPolicy::Scope do
    let(:scope) { Account.all }
    let(:account_policy_scope) { described_class.new(user, scope).resolve }

    it { expect(account_policy_scope).to eq [] }
  end

  context 'for member access via "customer" role' do
    before { user.add_role(:customer, account) }

    # Only system admins can create accounts right now. This should be refactored
    # to allow users with the "customer" role to create accounts once the app
    # is ready for that.
    describe '#create?' do
      it { expect(account_policy.create?).to be false }
    end

    describe '#accessible_to_user?', skip: 'TODO: model scope for account access via "customer" role' do
      it { expect(account_policy.accessible_to_user?).to be true }
    end
  end

  pending 'for member access via "contact" role'
end
