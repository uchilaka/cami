# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  let(:account) do
    Account.create!(
      display_name: 'MyString',
      slug: 'MyString',
      status: 1,
      type: '',
      tax_id: 'MyString',
      readme: 'MyText'
    )
  end

  before(:each) do
    assign(:account, account)
  end

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(account), 'post' do
      assert_select 'input[name=?]', 'account[display_name]'

      assert_select 'input[name=?]', 'account[slug]'

      assert_select 'input[name=?]', 'account[status]'

      assert_select 'input[name=?]', 'account[type]'

      assert_select 'input[name=?]', 'account[tax_id]'

      assert_select 'textarea[name=?]', 'account[readme]'
    end
  end
end
