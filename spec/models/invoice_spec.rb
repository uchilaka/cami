# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                        :uuid             not null, primary key
#  amount_cents              :integer          default(0), not null
#  amount_currency           :string           default("USD"), not null
#  due_amount_cents          :integer          default(0), not null
#  due_amount_currency       :string           default("USD"), not null
#  due_at                    :datetime
#  invoice_number            :string
#  invoiceable_type          :string
#  invoicer                  :jsonb
#  issued_at                 :datetime
#  links                     :jsonb
#  metadata                  :jsonb
#  notes                     :text
#  paid_at                   :datetime
#  payment_vendor            :string
#  payments                  :jsonb
#  status                    :integer
#  type                      :string           default("Invoice")
#  updated_accounts_at       :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invoiceable_id            :uuid
#  vendor_record_id          :string
#  vendor_recurring_group_id :string
#
# Indexes
#
#  index_invoices_on_invoiceable                          (invoiceable_type,invoiceable_id)
#  index_invoices_on_invoiceable_type_and_invoiceable_id  (invoiceable_type,invoiceable_id)
#
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:account) { Fabricate :account }

  subject { Fabricate(:invoice, invoiceable: account) }

  # The basics
  it { is_expected.to have_many(:roles).dependent(:destroy) }

  describe '#status' do
    # draft or scheduled to sent on send_bill
    it { is_expected.to transition_from(:draft).to(:sent).on_event(:send_bill) }
    it { is_expected.to transition_from(:scheduled).to(:sent).on_event(:send_bill) }

    # sent, scheduled, unpaid, payment_pending OR partially_paid to paid on paid_in_full
    it { is_expected.to transition_from(:scheduled).to(:paid).on_event(:paid_in_full) }
    it { is_expected.to transition_from(:sent).to(:paid).on_event(:paid_in_full) }
    it { is_expected.to transition_from(:unpaid).to(:paid).on_event(:paid_in_full) }
    it { is_expected.to transition_from(:payment_pending).to(:paid).on_event(:paid_in_full) }
    it { is_expected.to transition_from(:partially_paid).to(:paid).on_event(:paid_in_full) }

    # sent, scheduled, unpaid, payment_pending OR partially_paid to marked_as_paid on paid_via_transfer
    it { is_expected.to transition_from(:scheduled).to(:marked_as_paid).on_event(:paid_via_transfer) }
    it { is_expected.to transition_from(:sent).to(:marked_as_paid).on_event(:paid_via_transfer) }
    it { is_expected.to transition_from(:unpaid).to(:marked_as_paid).on_event(:paid_via_transfer) }
    it { is_expected.to transition_from(:payment_pending).to(:marked_as_paid).on_event(:paid_via_transfer) }
    it { is_expected.to transition_from(:partially_paid).to(:marked_as_paid).on_event(:paid_via_transfer) }

    # sent, scheduled, unpaid OR payment_pending to partially_paid on partial_payment
    it { is_expected.to transition_from(:sent).to(:partially_paid).on_event(:partial_payment) }
    it { is_expected.to transition_from(:scheduled).to(:partially_paid).on_event(:partial_payment) }
    it { is_expected.to transition_from(:unpaid).to(:partially_paid).on_event(:partial_payment) }
    it { is_expected.to transition_from(:payment_pending).to(:partially_paid).on_event(:partial_payment) }

    # sent, scheduled, unpaid OR payment_pending to unpaid on late_payment_30_days
    it { is_expected.to transition_from(:sent).to(:unpaid).on_event(:late_payment_30_days) }
    it { is_expected.to transition_from(:scheduled).to(:unpaid).on_event(:late_payment_30_days) }
    it { is_expected.to transition_from(:unpaid).to(:unpaid).on_event(:late_payment_30_days) }
    it { is_expected.to transition_from(:payment_pending).to(:unpaid).on_event(:late_payment_30_days) }

    # sent, scheduled, unpaid OR payment_pending to canceled on late_payment_90_days
    it { is_expected.to transition_from(:sent).to(:unpaid).on_event(:late_payment_90_days) }
    it { is_expected.to transition_from(:scheduled).to(:unpaid).on_event(:late_payment_90_days) }
    it { is_expected.to transition_from(:unpaid).to(:unpaid).on_event(:late_payment_90_days) }
    it { is_expected.to transition_from(:payment_pending).to(:unpaid).on_event(:late_payment_90_days) }

    it 'is draft by default' do
      expect(subject.status).to eq 'draft'
    end
  end

  describe 'when accessed' do
    let(:user) { Fabricate :user }
    let(:account) { Fabricate :account }

    context 'by a user' do
      context 'with a "customer" role on the invoice' do
        before { user.add_role(:customer, subject) }

        it { expect(user.has_role?(:customer, subject)).to be true }
      end
      pending 'with a "contact" role on the invoice'
    end
  end
end
