# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'accounts/show', type: :view do
  before(:each) do
    assign(:account, Account.create!(
                       display_name: 'Business Name',
                       readme: 'MyText'
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Business Name/)
  end
end
