# frozen_string_literal: true

json.extract! metadata_profile, :id, :phone, :image_url, :created_at, :updated_at, :last_seen_at

json.identities do
  json.google do
    json.partial! 'profiles/identities/google', identity: metadata_profile.google
  end
  json.apple do
    json.partial! 'profiles/identities/apple', identity: metadata_profile.apple
  end
end

json.url account_profile_url(account, metadata_profile, format: :json)
