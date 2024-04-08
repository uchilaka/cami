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
Fabricator(:product) do
  sku { Faker::Barcode.ean }
  display_name { Faker::Commerce.product_name }
  description { Faker::Marketing.buzzwords }
  data         '{}'
  vendor       { Fabricate(:business) }
end
