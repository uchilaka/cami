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
#
Fabricator(:account) do
  transient :users

  display_name { Faker::Company.name }
  users { [Fabricate(:user)] }
  slug { SecureRandom.alphanumeric(4).downcase }
  type 'Account'

  after_build do |account, transients|
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
