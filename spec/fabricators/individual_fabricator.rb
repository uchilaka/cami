# frozen_string_literal: true

Fabricator(:individual, from: :account) do
  display_name do
    [
      Faker::Name.gender_neutral_first_name,
      Faker::Name.middle_name,
      Faker::Name.last_name
    ].join(' ')
  end
end
