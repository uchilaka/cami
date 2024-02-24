# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/show', type: :view do
  before(:each) do
    assign(:service, Service.create!(
                       display_name: 'Display Name',
                       readme: 'MyText'
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/MyText/)
  end
end
