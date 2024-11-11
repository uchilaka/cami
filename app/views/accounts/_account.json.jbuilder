# frozen_string_literal: true

json.extract! account, :id, :display_name, :slug, :status, :type, :tax_id, :readme, :created_at, :updated_at
json.url account_url(account, format: :json)
