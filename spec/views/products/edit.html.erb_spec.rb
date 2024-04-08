# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/edit', type: :view do
  let(:user) { Fabricate :user }
  let(:vendor) { Fabricate :business, users: [user] }
  let(:product) { Fabricate :product, vendor: }

  before(:each) do
    sign_in :user
    assign(:product, product)
  end

  it 'renders the edit product form' do
    render

    assert_select 'form[action=?][method=?]', product_path(product), 'post' do
      assert_select 'input[name=?]', 'product[sku]'

      assert_select 'input[name=?]', 'product[display_name]'

      assert_select 'input[name=?][type=?]', 'product[description]', 'hidden'

      assert_select 'trix-editor[id=?]', 'product_description'
    end
  end
end
