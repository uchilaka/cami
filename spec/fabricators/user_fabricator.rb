# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  family_name            :string
#  given_name             :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
Fabricator(:user) do
  email { Faker::Internet.email }
  given_name { Faker::Name.gender_neutral_first_name }
  family_name { Faker::Name.last_name }
  password { Faker::Internet.password(min_length: 8) }

  # after_build do |attrs|
  #   Fabricate.build(:user_profile, user_id: attrs.id)
  # end
end
