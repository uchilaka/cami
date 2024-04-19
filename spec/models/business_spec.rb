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
require 'rails_helper'

RSpec.describe Business, type: :model do
  subject { Fabricate :business }

  it { should have_and_belong_to_many(:users) }
  it { should have_many(:products).with_foreign_key(:vendor_id) }
end
