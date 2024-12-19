# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'invoices/index', type: :view do
  let(:invoiceable) { Fabricate :account }
  before(:each) do
    assign(
      :invoices,
      [
        Fabricate(:invoice, invoiceable:, invoice_number: 'INV-01', amount: '9.99', due_amount: '7.99'),
        Fabricate(:invoice, invoiceable:, invoice_number: 'INV-02', amount: '9.99', due_amount: '7.99'),
      ]
    )
  end

  it 'renders a list of invoices' do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new('Invoice #'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('INV-'), count: 2
    assert_select cell_selector, text: Regexp.new('9.99'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('7.99'.to_s), count: 2
  end
end
