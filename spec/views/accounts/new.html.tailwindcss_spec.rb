require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before(:each) do
    assign(:account, Account.new(
      display_name: "MyString",
      slug: "MyString",
      status: 1,
      type: "",
      tax_id: "MyString",
      readme: "MyText"
    ))
  end

  it "renders new account form" do
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do

      assert_select "input[name=?]", "account[display_name]"

      assert_select "input[name=?]", "account[slug]"

      assert_select "input[name=?]", "account[status]"

      assert_select "input[name=?]", "account[type]"

      assert_select "input[name=?]", "account[tax_id]"

      assert_select "textarea[name=?]", "account[readme]"
    end
  end
end
