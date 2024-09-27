# frozen_string_literal: true

Fabricator(:invoice) do
  payment_vendor 'paypal'
  accounts []
end

Fabricator(:invoice_with_accounts, from: :invoice) do
  accounts do
    [
      # Individual account
      {
        email: Faker::Internet.email,
        given_name: Faker::Name.gender_neutral_first_name,
        family_name: Faker::Name.last_name,
        type: 'Individual'
      },
      # Business account
      {
        email: Faker::Internet.email,
        display_name: Faker::Company.name,
        type: 'Business'
      }
    ]
  end

  after_build do |invoice|
    invoice.accounts.each do |account|
      next if account[:type] == 'Business'

      account[:display_name] = "#{account[:given_name]} #{account[:family_name]}"
    end
  end
end
