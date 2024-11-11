require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        display_name: "Display Name",
        slug: "Slug",
        status: 2,
        type: "Type",
        tax_id: "Tax",
        readme: "MyText"
      ),
      Account.create!(
        display_name: "Display Name",
        slug: "Slug",
        status: 2,
        type: "Type",
        tax_id: "Tax",
        readme: "MyText"
      )
    ])
  end

  it "renders a list of accounts" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Display Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Slug".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Tax".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
