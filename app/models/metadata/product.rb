# frozen_string_literal: true

module Metadata
  class Product
    include DocumentRecord

    field :product_id, type: String
    field :links, type: Array, overwrite: true

    validates :product_id, presence: true, uniqueness: { case_sensitive: false }

    def product
      @product ||= ::Product.find(product_id)
    end
  end
end
