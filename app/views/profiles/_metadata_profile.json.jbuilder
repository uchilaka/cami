# frozen_string_literal: true

json.extract! metadata_profile, :id, :phone, :image_url, :created_at, :updated_at, :last_seen_at

json.url account_profile_url(account, metadata_profile, format: :json)
