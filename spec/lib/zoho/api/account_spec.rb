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
    end
  end
end
