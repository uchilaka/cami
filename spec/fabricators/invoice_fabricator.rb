# frozen_string_literal: true

Fabricator(:invoice) do
  payment_vendor 'paypal'
  accounts do
    [{ email: Faker::Internet.email, display_name: Faker::Company.name }]
  end
end
