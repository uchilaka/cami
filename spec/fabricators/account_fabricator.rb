# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  metadata     :jsonb
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
require 'phonelib'

Fabricator(:account) do
  transient             :phone_number
  transient             :country_alpha2
  transient             :users

  display_name          { Faker::Company.name }
  # users                 { [Fabricate(:user)] }
  slug                  { SecureRandom.alphanumeric(4).downcase }
  tax_id                { Faker::Company.ein }
  type                  'Account'

  phone do |attrs|
    phone_input = attrs[:phone_number] || '+2347129248348'
    country_alpha2 =
      if attrs[:phone_number].present?
        attrs[:country_alpha2]
      else
        'NG'
      end
    phone_number = Phonelib.parse(phone_input, country_alpha2)
    {
      full_e164: phone_number.full_e164,
      country: phone_number.country
    }
  end

  # TODO: Should not need to handle users transiently, since active record
  #   should just work when the users array argument is provided 🤞🏾
  after_create do |account, transients|
    if transients[:users].is_a?(Array)
      transients[:users].each do |user|
        account.users << user
      end
    end
  end
end

Fabricator(:account_with_invoices, from: :account) do
  transient :invoices

  after_build do |account, transients|
    if transients[:invoices].is_a?(Array)
      transients[:invoices].each do |invoice|
        account.add_role(:customer, invoice.record)
      end
    end
  end
end
