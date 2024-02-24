# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id            :uuid             not null, primary key
#  business_name :string
#  readme        :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tax_id        :string
#
class Account < ApplicationRecord
end
