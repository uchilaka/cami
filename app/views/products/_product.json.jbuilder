# frozen_string_literal: true

json.extract! product, :id, :sku, :display_name, :description, :data, :created_at, :updated_at
json.url product_url(product, format: :json)
