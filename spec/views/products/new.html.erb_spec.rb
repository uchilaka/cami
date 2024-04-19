# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/new', type: :view do
  let(:user) { Fabricate :user }
  let(:vendors) { Business.all }

  before(:each) do
    sign_in :user
    assign(:product, Product.new)
    assign(:vendors, vendors)
  end

  it 'renders new product form' do
    render

    assert_select 'form[action=?][method=?]', products_path, 'post' do
      assert_select 'input[name=?]', 'product[sku]'

      assert_select 'input[name=?]', 'product[display_name]'

      assert_select 'input[name=?][type=?]', 'product[description]', 'hidden'

      assert_select 'trix-editor[id=?][input=?]', 'product_description', 'product_description_trix_input_product'
    end
  end
end
