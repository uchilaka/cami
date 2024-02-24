# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id           :uuid             not null, primary key
#  data         :json
#  description  :text
#  display_name :string
#  sku          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  vendor_id    :uuid
#
# Foreign Keys
#
#  fk_rails_...  (vendor_id => accounts.id)
#
class Product < ApplicationRecord
  belongs_to :vendor, class_name: 'Account'
  has_and_belongs_to_many :services
end
