# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
class Business < Account
  has_many :products, foreign_key: :vendor_id
  has_and_belongs_to_many :users, class_name: 'Account'

  validates :tax_id, allow_blank: true, uniqueness: { case_sensitive: false }
end
