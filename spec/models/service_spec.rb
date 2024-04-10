# frozen_string_literal: true

# == Schema Information
#
# Table name: services
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Service, type: :model do
  it { is_expected.to have_and_belong_to_many(:products) }
end
