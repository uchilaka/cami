# frozen_string_literal: true

# 20240224132901_create_services_products.rb
class CreateProductsServices < ActiveRecord::Migration[7.0]
  def change
    # NOTE: This results in a join table :products_services with UUID FK columns service_id and product_id.
    #   Hint: The order of the tables in the create_join_table method isn't important - it seems to be
    #   alphabetical when it calculates the name of the table.
    create_join_table :products, :services, column_options: { type: :uuid }, &:timestamps
  end
end
