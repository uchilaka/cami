# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/show', type: :view do
  before(:each) do
    assign(:product, Product.create!(
                       sku: 'Sku',
                       display_name: 'Display Name',
                       description: 'MyText',
                       data: ''
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Sku/)
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
