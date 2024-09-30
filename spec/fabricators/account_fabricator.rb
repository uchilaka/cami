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
      account.save!
    end
  end
end
