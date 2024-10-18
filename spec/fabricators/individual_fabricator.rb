# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  slug         :string
#  status       :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
# Indexes
#
#  index_accounts_on_slug    (slug) UNIQUE
#  index_accounts_on_tax_id  (tax_id) UNIQUE WHERE (tax_id IS NOT NULL)
#
Fabricator(:individual, from: :account) do
  type 'Individual'
  display_name do
    [
      Faker::Name.gender_neutral_first_name,
      Faker::Name.middle_name,
      Faker::Name.last_name
    ].join(' ')
  end

  transient :profiles

  after_create do |individual, transients|
    if transients[:profiles].is_a?(Array)
      transients[:profiles].each do |profile|
        raise Errors::DataModelViolation, 'Profile must be a Metadata::Profile' unless profile.is_a?(Metadata::Profile)

        profile.update(account_id: individual.id.to_s)
      end
    end
  end
end

Fabricator(:individual_with_profiles, from: :individual) do
  profiles do
    given_name = Faker::Name.neutral_first_name
    family_name = Faker::Name.last_name
    supported_vendor_keys = %i[facebook google apple]
    linked_profiles = supported_vendor_keys.map do |vendor_key|
      profile_data = {
        "#{vendor_key}": {
          given_name:,
          family_name:,
          email: Faker::Internet.email(
            name: "#{given_name} #{family_name}",
            separators: ['.'],
            domain: Faker::Internet.domain_name
          )
        }
      }.symbolize_keys
      Fabricate(:user_profile, **profile_data)
    end
    linked_profiles
  end
end
