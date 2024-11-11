# == Schema Information
#
# Table name: identity_provider_profiles
#
#  id                   :uuid             not null, primary key
#  confirmation_sent_at :datetime
#  display_name         :string
#  email                :string
#  email_verified       :boolean
#  family_name          :string           default("")
#  given_name           :string           default("")
#  image_url            :string
#  metadata             :jsonb
#  provider_name        :string
#  unverified_email     :string
#  verified             :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :uuid             not null
#
# Indexes
#
#  index_identity_provider_profiles_on_user_id                    (user_id)
#  index_identity_provider_profiles_on_user_id_and_provider_name  (user_id,provider_name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
Fabricator(:identity_provider_profile) do
  user                 nil
  provider_name        "MyString"
  verified             false
  email                "MyString"
  unverified_email     "MyString"
  email_verified       false
  given_name           "MyString"
  family_name          "MyString"
  display_name         "MyString"
  image_url            "MyString"
  confirmation_sent_at "2024-11-10 23:00:52"
  metadata             ""
end
