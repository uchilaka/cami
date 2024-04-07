# frozen_string_literal: true

Fabricator('Metadata::Profile') do
  google { { 'id' => SecureRandom.uuid } }
  facebook { { 'id' => SecureRandom.uuid } }
  apple { { 'id' => SecureRandom.uuid } }
  image_url { Faker::Avatar.image }
  last_seen_at { Time.now }
end

Fabricator(:user_profile, from: 'Metadata::Profile')
