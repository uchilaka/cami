# frozen_string_literal: true

json.extract! metadata_profile, :id, :created_at, :updated_at
json.url account_profile_url(@account, metadata_profile, format: :json)
