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
require 'rails_helper'

RSpec.describe Product, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
