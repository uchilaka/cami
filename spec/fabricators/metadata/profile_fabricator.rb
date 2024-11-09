# frozen_string_literal: true

Fabricator('Metadata::Profile') do
  google { { 'id' => SecureRandom.uuid } }
  facebook { { 'id' => SecureRandom.uuid } }
  apple { { 'id' => SecureRandom.uuid } }
  image_url { Faker::Avatar.image }
  last_seen_at { Time.now }

  transient :account
  transient :user

  after_build do |profile, transients|
    account, user = transients.values_at :account, :user
    profile.account_id = account.id if account.is_a?(Individual)
    profile.user_id = user.id if user.is_a?(User)
    profile.save! if profile.changed?
  end
end

Fabricator(:user_profile, from: 'Metadata::Profile')
