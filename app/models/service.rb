# frozen_string_literal: true

# == Schema Information
#
# Table name: services
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Service < ApplicationRecord
  # Account/User roles
  # ==================
  # :subscriber
  # :administrator
  # :owner
  # :auditor - is able to try the service for a limited time (e.g. testing, or trial period) without a subscription
  resourcify

  has_and_belongs_to_many :products, join_table: 'products_services'
end
