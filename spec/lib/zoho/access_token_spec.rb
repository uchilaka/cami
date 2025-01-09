# frozen_string_literal: true

require 'rails_helper'

module Zoho
  RSpec.describe AccessToken do
    describe '#generate' do
      it 'returns a hash with the access token' do
        response = described_class.generate
        expect(response).to be_a(Hash)
        expect(response.keys).to include('access_token')
        expect(response.keys).to include('scope')
        expect(response.keys).to include('expires_in')
        expect(response.keys).to include('api_domain')
        expect(response.keys).to include('token_type')
      end
    end
  end
end
