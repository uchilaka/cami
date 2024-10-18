# frozen_string_literal: true

json.extract! metadata_profile, :id, :created_at, :updated_at
json.url metadata_profile_url(metadata_profile, format: :json)
