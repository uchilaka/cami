# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/edit', type: :view do
  let(:product) do
    Product.create!(
      sku: 'MyString',
      display_name: 'MyString',
      description: 'MyText',
      data: ''
    )
  end

  before(:each) do
    assign(:product, product)
  end

  it 'renders the edit product form' do
    render

    assert_select 'form[action=?][method=?]', product_path(product), 'post' do
      assert_select 'input[name=?]', 'product[sku]'

      assert_select 'input[name=?]', 'product[display_name]'

      assert_select 'textarea[name=?]', 'product[description]'

      assert_select 'input[name=?]', 'product[data]'
    end
  end
end
