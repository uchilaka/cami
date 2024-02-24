# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/new', type: :view do
  before(:each) do
    assign(:account, Account.new(
                       business_name: 'MyString',
                       readme: 'MyText'
                     ))
  end

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', accounts_path, 'post' do
      assert_select 'input[name=?]', 'account[business_name]'

      assert_select 'textarea[name=?]', 'account[readme]'
    end
  end
end
