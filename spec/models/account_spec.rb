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
require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#display_name' do
    it 'is required' do
      account = Fabricate.build :account, display_name: nil
      expect(account).to be_invalid
      expect(account.errors[:display_name]).to include("can't be blank")
    end
  end
end
