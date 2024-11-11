# frozen_string_literal: true

Fabricator(:user) do
  email         { Faker::Internet.email }
  given_name    { Faker::Name.gender_neutral_first_name }
  family_name   { Faker::Name.last_name }
  password      { Faker::Internet.password(min_length: 8) }

  # after_build do |attrs|
  #   Fabricate.build(:user_profile, user_id: attrs.id)
  # end
end

Fabricator(:user_with_provider_profile, from: :user) do
  providers   { ['google'] }
  uids        { { 'google' => SecureRandom.alphanumeric(21) } }
end
