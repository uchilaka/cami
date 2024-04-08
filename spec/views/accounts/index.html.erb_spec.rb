# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/index', type: :view do
  before(:each) do
    assign(:accounts, [
             Account.create!(
               display_name: 'Business Name',
               readme: 'MyText'
             ),
             Account.create!(
               display_name: 'Business Name',
               readme: 'MyText'
             )
           ])
  end

  xit 'renders a list of accounts' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Business Name'.to_s), count: 2
    # assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
  end
end
