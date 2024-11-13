# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicePolicy do
  let(:user) { Fabricate :user }
  let(:account) { Fabricate :account }
  let(:invoice) { Fabricate :invoice, invoiceable: account }
  let(:invoice_policy) { described_class.new(user, invoice) }

  describe '#create?' do
    it { expect(invoice_policy.create?).to be false }
  end

  describe '#accessible_to_user?' do
    it { expect(invoice_policy.accessible_to_user?).to be false }
  end

  describe InvoicePolicy::Scope do
    let(:scope) { Invoice.all }
    let(:invoice_policy_scope) { described_class.new(user, scope).resolve }

    it { expect(invoice_policy_scope).to eq [] }
  end

  context 'for member access via "customer" role' do
    before { user.add_role(:customer, account) }

    # Only system admins can create invoices right now. This should be refactored
    # to allow users with the "customer" role to create invoices once the app
    # is ready for that.
    describe '#create?' do
      it { expect(invoice_policy.create?).to be false }
    end

    describe '#accessible_to_user?', skip: 'TODO: model scope for invoice access via "customer" role' do
      it { expect(invoice_policy.accessible_to_user?).to be true }
    end
  end

  pending 'for member access via "contact" role'
end
