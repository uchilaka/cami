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
    metadata.email = value
  end

  def metadata
    @metadata ||=
      if new_record?
        initialize_profile
      else
        Metadata::Business.find_or_create_by(account_id: id)
      end
  end

  alias profile metadata

  def initialize_metadata
    @metadata ||= Metadata::Business.find_or_initialize_by(account_id: id)
    @metadata.account_id ||= id
    @metadata.save if @metadata.changed? && persisted?
    @metadata
  end

  alias initialize_profile initialize_metadata
end
