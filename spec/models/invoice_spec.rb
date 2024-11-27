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
    it { transition_from(%i[draft scheduled]).to(:sent).on_event(:send_bill) }

    it do
      transition_from(%i[sent scheduled unpaid payment_pending partially_paid])
        .to(:paid)
        .on_event(:paid_in_full)
    end

    it do
      transition_from(%i[sent scheduled unpaid payment_pending partially_paid])
        .to(:paid)
        .on_event(:paid_via_transfer)
    end

    it do
      transition_from(%i[sent scheduled unpaid payment_pending partially_paid])
        .to(:partially_paid)
        .on_event(:partial_payment)
    end

    it do
      transition_from(%i[sent scheduled unpaid payment_pending])
        .to(:unpaid)
        .on_event(:late_payment_30_days)
    end

    it do
      transition_from(%i[sent scheduled unpaid payment_pending])
        .to(:unpaid)
        .on_event(:late_payment_90_days)
    end

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
