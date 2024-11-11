require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    assign(:account, Account.create!(
      display_name: "Display Name",
      slug: "Slug",
      status: 2,
      type: "Type",
      tax_id: "Tax",
      readme: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Tax/)
    expect(rendered).to match(/MyText/)
  end
end
