# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  subject { Fabricate :business }

  it { should validate_uniqueness_of(:tax_id).case_insensitive }
end
