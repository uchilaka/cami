# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VirtualOfficeManager do
  describe '.default_entity' do
    subject { described_class.default_entity }

    it 'returns the default entity' do
      expect(subject).to eq Rails.application.credentials&.entities&.larcity
    end
  end

  describe '.entity_by_key' do
    subject { described_class.entity_by_key(entity_key) }

    context 'when entity_key is :larcity' do
      let(:entity_key) { :larcity }

      it 'returns the larcity entity' do
        expect(subject).to eq Rails.application.credentials&.entities&.larcity
      end
    end

    context 'when entity_key is :some_other_key' do
      let(:entity_key) { :some_other_key }
      let(:mock_entity) do
        OpenStruct.new(
          name: Faker::Company.name,
          email: Faker::Internet.email,
          tax_id: Faker::Company.ein
        )
      end

      before do
        allow(Rails.application.credentials&.entities).to \
          receive(:some_other_key) { mock_entity }
      end

      it 'returns the entity with the key :some_other_key' do
        expect(subject).to eq Rails.application.credentials&.entities&.some_other_key
      end
    end

    context 'when entity_key is nil' do
      let(:entity_key) { nil }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when there is no entity for the sent key in the config' do
      let(:entity_key) { :non_existent_key }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
