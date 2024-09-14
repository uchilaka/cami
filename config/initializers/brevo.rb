# frozen_string_literal: true

require 'sib-api-v3-sdk'

SibApiV3Sdk.configure do |config|
  config.api_key['api-key'] = ENV.fetch('BREVO_V3_API_KEY', Rails.application.credentials.brevo.v3_api_key)
end
