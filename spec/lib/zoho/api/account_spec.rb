# frozen_string_literal: true

require 'rails_helper'

module Zoho
  module API
    RSpec.describe Account do
      describe '#resource_url' do
        it 'returns the expected accounts URL' do
          expect(described_class.resource_url).to eq('https://accounts.zoho.com')
        end
      end

      describe '#base_url' do
        it { expect(described_class.base_url).to eq('https://www.zohoapis.com') }
      end

      describe '#upsert' do
        let(:display_name) { Faker::Company.name }
        let(:email) { Faker::Internet.email }
        let(:record) { Fabricate(:account, display_name:, email:) }
        let(:inserted_record) { subject.dig('data', 0) }
        let(:inserted_record_details) { inserted_record['details'] }

        # How to use:
        # ===========
        # 1. Comment out the "Mock setup" section
        # 2. To generate a new cassette:
        #   - Uncomment the "VCR configuration" section
        #   - Delete the existing cassette file (at spec/fixtures/cassettes/zoho/upsert_accounts.yml)
        #   - Run the test
        # 3. To run a live request:
        #   - Comment out the "VCR configuration" section
        #   - Run the test
        # ===========

        # Mock setup
        let(:access_token) { 'test_access_token' }
        let(:response_body) do
          {
            'data' => [
              {
                'code' => 'SUCCESS',
                'details' => {
                  'id' => SecureRandom.uuid
                },
                'message' => 'record added successfully',
                'status' => 'success',
                'action' => 'insert'
              }
            ]
          }
        end
        let(:response) { double('response', body: response_body) }

        before do
          allow(AccessToken).to receive(:generate).and_return('access_token' => access_token)
          allow(described_class).to receive(:connection).with(access_token:).and_return(double(post: response))
        end
        # End mock setup

        # VCR configuration
        # let(:cassette) { vcr_cassettes[:zoho] }
        #
        # around do |example|
        #   VCR.use_cassette('zoho/upsert_accounts', cassette[:options]) { example.run }
        # end
        # End VCR configuration

        subject { described_class.upsert(record) }

        it 'returns a hash with the upserted record' do
          expect(subject).to be_a(Hash)
          expect(subject.keys).to include('data')
          expect(subject['data']).to be_a(Array)
          expect(subject['data'].size).to eq(1)
          expect(inserted_record['code']).to eq 'SUCCESS'
          expect(inserted_record['action']).to eq 'insert'
          expect(inserted_record['status']).to eq 'success'
          expect(inserted_record_details['id']).to be_present
        end
      end
    end
  end
end
