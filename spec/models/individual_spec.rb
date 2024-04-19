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
# Indexes
#
#  index_accounts_on_slug    (slug) UNIQUE
#  index_accounts_on_tax_id  (tax_id) UNIQUE WHERE (tax_id IS NOT NULL)
#
require 'rails_helper'

RSpec.describe Individual, type: :model do
  it { should have_and_belong_to_many(:users) }

  it 'should allow only one user' do
    individual = Fabricate :individual
    expect(individual).to be_valid
    individual.users << Fabricate(:user)
    expect(individual).not_to be_valid
  end
end
