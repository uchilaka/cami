# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  let(:account) do
    Account.create!(
      business_name: 'MyString',
      readme: 'MyText'
    )
  end

  before(:each) do
    assign(:account, account)
  end

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(account), 'post' do
      assert_select 'input[name=?]', 'account[business_name]'

      assert_select 'textarea[name=?]', 'account[readme]'
    end
  end
end
