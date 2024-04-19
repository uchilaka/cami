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
end
