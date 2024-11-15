# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invoices/new', type: :view do
  let(:user) { Fabricate :user }
  let(:invoice) { Fabricate :invoice, invoiceable: user }

  before(:each) do
    sign_in user
    allow(view).to receive(:current_user).and_return(user)
    assign(
      :invoice,
      Invoice.new(
        invoiceable: user,
        invoice_number: 'MyString',
        status: 1,
        amount_cents: 999,
        due_amount_cents: 999,
        notes: 'MyText'
      )
    )
  end

  it 'renders new invoice form' do
    render

    assert_select 'form[action=?][method=?]', invoices_path, 'post' do
      assert_select 'input[name=?]', 'invoice[invoice_number]'

      assert_select 'input[name=?]', 'invoice[status]'

      assert_select 'input[name=?]', 'invoice[amount]'

      assert_select 'input[name=?]', 'invoice[due_amount]'

      assert_select 'input[name=?]', 'invoice[currency_code]'

      assert_select 'textarea[name=?]', 'invoice[notes]'
    end
  end
end
