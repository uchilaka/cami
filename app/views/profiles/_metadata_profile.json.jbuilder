# frozen_string_literal: true

json.extract! metadata_profile, :created_at, :updated_at
json.phone metadata_profile.phone&.full_e164

if metadata_profile.is_a?(Metadata::Business)
  json.email metadata_profile.email

elsif metadata_profile.is_a?(Metadata::Profile)
  json.extract! metadata_profile, :given_name, :family_name, :image_url, :last_seen_at

  json.identities do
    json.google do
      json.partial! 'profiles/identities/google', identity: metadata_profile.google
    end
    json.apple do
      json.partial! 'profiles/identities/apple', identity: metadata_profile.apple
    end
  end
end

json.id metadata_profile.id.to_s
json.url account_profile_url(account, metadata_profile.id.to_s, format: :json)
