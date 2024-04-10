# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  slug         :string
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#

# Doc on Rails STI: https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
class Account < ApplicationRecord
  has_rich_text :readme
  # There are security implications to consider when using deterministic encryption.
  # See https://guides.rubyonrails.org/active_record_encryption.html#deterministic-and-non-deterministic-encryption
  encrypts :tax_id, deterministic: true

  attribute :type, :string, default: 'Account'
  attribute :slug, :string, default: -> { SecureRandom.alphanumeric(4).downcase }

  validates :display_name, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :users, join_table: 'accounts_users'

  def email
    nil
  end
end
