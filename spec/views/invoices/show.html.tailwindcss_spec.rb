require 'rails_helper'

RSpec.describe "invoices/show", type: :view do
  before(:each) do
    assign(:invoice, Invoice.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Invoiceable Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Invoice Number/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Currency Code/)
    expect(rendered).to match(/MyText/)
  end
end
