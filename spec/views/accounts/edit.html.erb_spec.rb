# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  let(:account) { Fabricate :account }

  before(:each) do
    assign(:account, account)
  end

  it 'renders the edit account form' do
    render

    assert_select 'form[action=?][method=?]', account_path(account), 'post' do
      assert_select 'input[name=?]', 'account[display_name]'

      assert_select 'input[name=?][type=?]', 'account[readme]', 'hidden'

      assert_select 'trix-editor[id=?]', 'account_readme'
    end
  end
end
