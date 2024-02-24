# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/edit', type: :view do
  let(:service) do
    Service.create!(
      display_name: 'MyString',
      readme: 'MyText'
    )
  end

  before(:each) do
    assign(:service, service)
  end

  it 'renders the edit service form' do
    render

    assert_select 'form[action=?][method=?]', service_path(service), 'post' do
      assert_select 'input[name=?]', 'service[display_name]'

      assert_select 'textarea[name=?]', 'service[readme]'
    end
  end
end
