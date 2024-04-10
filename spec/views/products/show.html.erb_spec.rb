# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/show', type: :view do
  let(:vendor) { Fabricate :business }
  let(:product) { Fabricate :product, vendor: }

  before(:each) do
    assign(:product, product)
  end

  it 'renders vendor name' do
    render
    expect(rendered).to match(Regexp.new(vendor.display_name.to_s))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(Regexp.new(product.sku.to_s))
    expect(rendered).to match(Regexp.new(product.display_name.to_s))
    expect(rendered).to match(Regexp.new(product.description.to_s))
  end
end
