require 'rails_helper'

RSpec.describe "invoices/index", type: :view do
  before(:each) do
    assign(:invoices, [
      Invoice.create!(
        invoiceable_id: "",
        invoiceable_type: "Invoiceable Type",
        account: nil,
        user: nil,
        payments: "",
        links: "",
        invoice_number: "Invoice Number",
        status: 2,
        amount: "9.99",
        due_amount: "9.99",
        currency_code: "Currency Code",
        notes: "MyText"
      ),
      Invoice.create!(
        invoiceable_id: "",
        invoiceable_type: "Invoiceable Type",
        account: nil,
        user: nil,
        payments: "",
        links: "",
        invoice_number: "Invoice Number",
        status: 2,
        amount: "9.99",
        due_amount: "9.99",
        currency_code: "Currency Code",
        notes: "MyText"
      )
    ])
  end

  it "renders a list of invoices" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Invoiceable Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Invoice Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Currency Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
