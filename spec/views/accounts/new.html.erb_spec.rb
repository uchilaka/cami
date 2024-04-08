# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/new', type: :view do
  before(:each) do
    assign(:account, Account.new(
                       display_name: 'MyString',
                       readme: 'MyText'
                     ))
  end

  it 'renders new account form' do
    render

    assert_select 'form[action=?][method=?]', accounts_path, 'post' do
      assert_select 'input[name=?]', 'account[display_name]'

      assert_select 'input[name=?][type=?]', 'account[readme]', 'hidden'

      assert_select 'trix-editor[id=?]', 'account_readme'
    end
  end
end
