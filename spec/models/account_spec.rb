# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
