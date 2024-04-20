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
class Individual < Account
  delegate :email, to: :user, allow_nil: true

  validate :allows_one_user

  def user
    users.first
  end

  def allows_one_user
    return unless users.count > 1

    errors.add(:users, I18n.t('models.account.errors.user_limit_exceeded'))
  end
end
