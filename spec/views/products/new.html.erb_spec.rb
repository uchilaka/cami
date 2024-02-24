# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/new', type: :view do
  before(:each) do
    assign(:product, Product.new(
                       sku: 'MyString',
                       display_name: 'MyString',
                       description: 'MyText',
                       data: ''
                     ))
  end

  it 'renders new product form' do
    render

    assert_select 'form[action=?][method=?]', products_path, 'post' do
      assert_select 'input[name=?]', 'product[sku]'

      assert_select 'input[name=?]', 'product[display_name]'

      assert_select 'textarea[name=?]', 'product[description]'

      assert_select 'input[name=?]', 'product[data]'
    end
  end
end
