# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
Fabricator(:business, from: :account) do
  type 'Business'
  tax_id { Faker::Company.ein }
  readme { Faker::Company.catch_phrase }
end
