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
class Business < Account
  include MaintainsMetadata

  delegate :email, to: :metadata, allow_nil: true

  has_many :products, foreign_key: :vendor_id

  validates :tax_id, allow_blank: true, uniqueness: { case_sensitive: false }

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
      profile.save if profile.changed? && profile.business&.persisted?
    else
      Metadata::Business.create(account_id: id)
    end
  end

  alias initialize_metadata initialize_profile
end
