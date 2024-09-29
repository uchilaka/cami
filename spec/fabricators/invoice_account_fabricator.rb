# frozen_string_literal: true

Fabricator(:invoice_account) do
  type { |attrs| attrs[:type] || 'Business' }
  email { Faker::Internet.email }
  display_name { |attrs| attrs[:display_name] || attrs[:email] }

  after_build do |account|
    account[:display_name] ||= account[:email]
  end
end

Fabricator(:business_invoice_account, from: :invoice_account) do
  type { 'Business' }
  display_name { Faker::Company.name }
end

Fabricator(:individual_invoice_account, from: :invoice_account) do
  type { 'Individual' }
  given_name { Faker::Name.neutral_first_name }
  family_name { Faker::Name.last_name }

  after_build do |account|
    account[:display_name] ||= "#{account[:given_name]} #{account[:family_name]}".strip
  end
end
