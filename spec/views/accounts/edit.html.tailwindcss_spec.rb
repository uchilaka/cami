# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  let(:user) { Fabricate :user }
  let(:account) { Fabricate :account, users: [user] }

  before(:each) do
    sign_in user
    assign(:account, account)
  end

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(account), 'post' do
      assert_select 'input[name=?]', 'account[display_name]'

      assert_select 'input[name=?]', 'account[slug]'

      assert_select 'select[name=?]', 'account[status]'

      assert_select 'input[name=?]', 'account[tax_id]'

      assert_select 'trix-editor#account_readme'

      assert_select 'input[type="hidden"][name=?]', 'account[readme]'
    end
  end
end
