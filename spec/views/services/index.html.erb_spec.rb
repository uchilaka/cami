# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/index', type: :view do
  before(:each) do
    assign(:services, [
             Service.create!(
               display_name: 'Display Name',
               readme: 'MyText'
             ),
             Service.create!(
               display_name: 'Display Name',
               readme: 'MyText'
             )
           ])
  end

  it 'renders a list of services' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Display Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'.to_s), count: 2
  end
end
