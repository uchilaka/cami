# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invoices/show', type: :view do
  let(:invoiceable) { Fabricate :account }
  let(:invoice) { Fabricate(:invoice, invoiceable:, invoice_number: 'INV-04', amount: '9.99', due_amount: '7.99') }
  before(:each) do
    assign(:invoice, invoice)
  end

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
