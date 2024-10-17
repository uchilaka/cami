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
class Business < Account
  include MaintainsMetadata

  # TODO: Determine best way to ensure business emails are captured
  #   without breaking automation for ingesting account information
  #   through invoice integration(s).
  validates :email, email: true, allow_nil: true

  delegate :email, :phone, to: :metadata, allow_nil: true

  has_many :products, foreign_key: :vendor_id, dependent: :nullify

  def email=(value)
    profile.email = value
  end

  def profile
    @metadata ||= Metadata::Business.find_or_create_by(account_id: id)
  end

  alias metadata profile

  def initialize_profile
    if profile.present?
      profile.account_id ||= id
      profile.save if profile.changed? && persisted?
    else
      Metadata::Business.create(account_id: id)
    end
  end

  alias initialize_metadata initialize_profile
end
