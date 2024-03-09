# frozen_string_literal: true

def find_or_create_mock_user!(attrs = {})
  email, = attrs.values_at :email
  existing_user = User.find_by(email:)
  return existing_user if existing_user

  init_attrs = {
    password: Faker::Internet.password(min_length: 8),
    email: Faker::Internet.email,
    first_name: Faker::Name.gender_neutral_first_name,
    last_name: Faker::Name.last_name
  }.merge(attrs)

  User.create!(**init_attrs)
end
