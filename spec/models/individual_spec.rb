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

RSpec.describe Individual, type: :model do
  it { should have_and_belong_to_many(:users) }

  it 'should allow only one user' do
    individual = Fabricate :individual
    expect(individual).to be_valid
    individual.users << Fabricate(:user)
    expect(individual).not_to be_valid
  end
end
