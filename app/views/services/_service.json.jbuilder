# frozen_string_literal: true

json.extract! service, :id, :display_name, :readme, :created_at, :updated_at
json.url service_url(service, format: :json)
