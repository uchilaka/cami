# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                  :uuid             not null, primary key
#  amount              :decimal(10, 2)
#  currency_code       :string
#  due_amount          :decimal(10, 2)
#  due_at              :datetime
#  invoice_number      :string
#  invoiceable_type    :string
#  issued_at           :datetime
#  links               :jsonb
#  notes               :text
#  paid_at             :datetime
#  payments            :jsonb
#  status              :integer
#  updated_accounts_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  invoiceable_id      :uuid
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
