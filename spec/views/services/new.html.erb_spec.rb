# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/new', type: :view do
  before(:each) do
    assign(:service, Service.new(
                       display_name: 'MyString',
                       readme: 'MyText'
                     ))
  end

  it 'renders new service form' do
    render

    assert_select 'form[action=?][method=?]', services_path, 'post' do
      assert_select 'input[name=?]', 'service[display_name]'

      assert_select 'textarea[name=?]', 'service[readme]'
    end
  end
end
