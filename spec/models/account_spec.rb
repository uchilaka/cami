# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  slug         :string
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { Fabricate :account }

  it { should validate_presence_of :display_name }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }
  it { should have_and_belong_to_many(:users) }
end
