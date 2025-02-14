# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invoices/show', type: :view do
  let(:invoiceable) { Fabricate :account }
  let(:invoice) { Fabricate(:invoice, invoiceable:, invoice_number: 'INV-04', amount: '9.99', due_amount: '7.99') }
  before(:each) do
    assign(:invoice, invoice)
  end

  pending 'A sent invoice should render the expected invoice item'
  pending 'A scheduled invoice should render the expected invoice item'
  pending 'A partially paid invoice should render the expected invoice item'
  pending 'A paid invoice should render the expected invoice item'
  pending 'A marked as paid invoice should render the expected invoice item'
  pending 'An unpaid invoice should render the expected invoice item'
  pending 'An overdue invoice should render the expected invoice item'

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Invoice #/)
    expect(rendered).to match(/INV-04/)
    expect(rendered).to match(/Invoice #/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/7.99/)
  end
end
