# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  let(:user) { Fabricate :user }

  before(:each) do
    assign(
      :accounts,
      [
        Fabricate(
          :account,
          display_name: 'Display Name',
          slug: 'slug-1',
          status: 'demo',
          tax_id: '01-23456789',
          readme: 'MyText',
          users: [user]
        ),
        Fabricate(
          :account,
          display_name: 'Display Name',
          slug: 'slug-2',
          status: 'guest',
          tax_id: '09-87654321',
          readme: 'MyText',
          users: [user]
        )
      ]
    )
  end

  context 'with a logged in user' do
    before { sign_in user }

    it 'renders a list of accounts' do
      render
      cell_selector = 'div>p'
      assert_select cell_selector, text: Regexp.new('Display Name'.to_s), count: 2
      assert_select cell_selector, text: Regexp.new('slug-1'.to_s), count: 1
      assert_select cell_selector, text: Regexp.new('slug-2'.to_s), count: 1
      assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
      assert_select cell_selector, text: Regexp.new('Tax'.to_s), count: 2
      assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
    end
  end
end
