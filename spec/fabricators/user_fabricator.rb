# frozen_string_literal: true

Fabricator(:user) do
  email { Faker::Internet.email }
  first_name { Faker::Name.gender_neutral_first_name }
  last_name  { Faker::Name.last_name }
  password { Faker::Internet.password(min_length: 8) }

  after_build do |user|
    Fabricate.build(:user_profile, user_id: user.id)
  end
end
