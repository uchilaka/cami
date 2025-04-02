# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id            :uuid             not null, primary key
#  discarded_at  :datetime
#  display_name  :string
#  email         :string
#  metadata      :jsonb
#  phone         :jsonb
#  readme        :text
#  slug          :string
#  status        :integer
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid
#  remote_crm_id :string
#  tax_id        :string
#
# Indexes
#
#  by_account_email_if_set         (email) UNIQUE WHERE (email IS NOT NULL)
#  by_account_tax_id_if_set        (tax_id) UNIQUE WHERE ((tax_id IS NOT NULL) AND (TRIM(BOTH FROM tax_id) <> ''::text))
#  index_accounts_on_discarded_at  (discarded_at)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => accounts.id)
#
class Individual < Account
  # See SO recommendation: https://stackoverflow.com/a/9463495/3726759
  def self.model_name
    Account.model_name
  end
end
