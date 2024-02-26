# frozen_string_literal: true

Fabricator(:business, from: :account) do
  type 'Business'
  tax_id { Faker::Company.ein }
  readme { Faker::Company.catch_phrase }
end
