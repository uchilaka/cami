# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.test_framework      :rspec, fixture_replacement: :fabrication
  g.fixture_replacement :fabrication, dir: 'spec/fabricators'
  g.orm :active_record, primary_key_type: :uuid
end
