# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  subject { Fabricate :business }

  describe '#tax_id' do
    let(:tax_id) { Faker::Company.ein }

    it 'validates uniqueness' do
      saved_record = Fabricate(:business, tax_id:)
      expect(saved_record).to be_valid
      expect(saved_record).to be_persisted
      # Attempt to create a new record with the same tax_id
      new_record = Fabricate.build(:business, tax_id:)
      expect(new_record).to be_invalid
    end
  end
end
