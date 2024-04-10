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
Fabricator(:account) do
  display_name { Faker::Company.name }
  users { [Fabricate(:user)] }
  slug { Faker::Internet.slug }
  type 'Account'
end
