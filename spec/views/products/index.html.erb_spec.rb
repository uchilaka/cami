# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/index', type: :view do
  let(:sku) { Faker::Barcode.ean }
  let(:display_name) { Faker::Commerce.product_name }
  let(:description) { Faker::Marketing.buzzwords }

  before(:each) do
    assign(
      :products, [
        Fabricate(:product, sku:, display_name:, description:),
        Fabricate(:product, sku:, display_name:, description:)
      ]
    )
  end

  it 'renders a list of products' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(sku.to_s), count: 2
    assert_select 'section>h4', text: Regexp.new(display_name.to_s), count: 2
    assert_select 'section>div.trix-content', text: Regexp.new(description.to_s), count: 2
  end
end
