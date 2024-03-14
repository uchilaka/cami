# frozen_string_literal: true

require 'rails_helper'

module LarCity
  RSpec.describe SignedGlobalIdTokenizer, type: :model do
    describe '.encode' do
      context 'with includes' do
        it 'encodes a resource' do
          resource = double
          expires_in = 1.hour
          purpose = 'sharing'
          signed_global_id = double
          includes = [:account]
          options = {}
          options[:expires_in] = expires_in.to_i
          options[:for] = purpose
          options[:includes] = includes
          expect(resource).to receive(:to_signed_global_id).with(options).and_return(signed_global_id)
          expect(described_class.encode(resource, expires_in:, purpose:, includes:)).to eq(signed_global_id)
        end
      end

      context 'without includes' do
        it 'encodes a resource' do
          resource = double
          expires_in = 1.hour
          purpose = 'sharing'
          signed_global_id = double
          options = {}
          options[:expires_in] = expires_in.to_i
          options[:for] = purpose
          expect(resource).to receive(:to_signed_global_id).with(options).and_return(signed_global_id)
          expect(described_class.encode(resource, expires_in:, purpose:)).to eq(signed_global_id)
        end
      end

      context 'for users' do
        let(:user) { Fabricate(:user) }
        let(:token) { described_class.encode(user) }

        it 'encodes the token' do
          expect(described_class.encode(user)).not_to be_nil
        end
      end
    end

    describe '.decode' do
      it 'decodes a token' do
        token = double
        resource_class = double
        includes = [:account]
        options = { only: resource_class }
        options[:includes] = includes
        resource = double
        expect(GlobalID::Locator).to receive(:locate_signed).with(token, options).and_return(resource)
        expect(described_class.decode(token, resource_class, includes:)).to eq(resource)
      end

      context 'for users' do
        let(:user) { Fabricate(:user) }
        let(:token) { described_class.encode(user) }

        it 'decodes the token' do
          expect(described_class.decode(token, 'User')).to eq(user)
        end
      end
    end
  end
end
