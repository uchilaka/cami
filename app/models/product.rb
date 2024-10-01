# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id           :uuid             not null, primary key
#  data         :json
#  display_name :string           not null
#  sku          :string
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  vendor_id    :uuid
#
# Foreign Keys
#
#  fk_rails_...  (vendor_id => accounts.id)
#
class Product < ApplicationRecord
  # Account/User roles
  # ==================
  # :customer
  # :reviewer
  # :auditor - is able to try the product for a limited time (e.g. testing, or trial period) without a subscription

  resourcify

  include MaintainsMetadata

  attribute :type, :string, default: 'Product'

  belongs_to :vendor, class_name: 'Account', optional: true

  has_and_belongs_to_many :services, join_table: 'products_services'

  delegate :links, to: :metadata

  has_rich_text :description

  def links=(value)
    metadata.links = value
  end

  def metadata
    @metadata ||= Metadata::Product.find_or_initialize_by(product_id: id)
  end

  def initialize_metadata
    if metadata.present?
      metadata.product_id ||= id
      metadata.save if metadata.changed? && metadata.product.persisted?
    else
      Metadata::Product.create(product_id: id)
    end
  end
end
