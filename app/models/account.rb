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

# Doc on Rails STI: https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
class Account < ApplicationRecord
  validates :display_name, presence: true
end
