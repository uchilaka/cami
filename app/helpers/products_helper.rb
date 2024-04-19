# frozen_string_literal: true

module ProductsHelper
  def modal_dom_id(product)
    "product-modal_#{product.id}"
  end

  def vendor_options
    @vendors.map { |v| [v.display_name, v.id] }
  end
end
