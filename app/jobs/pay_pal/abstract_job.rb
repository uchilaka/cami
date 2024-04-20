# frozen_string_literal: true

module PayPal
  class AbstractJob < ApplicationJob
    queue_as :yeet

    def connection
      @connection ||= Faraday.new(
        url: vendor_credentials.base_url,
        headers: {
          'Content-Type': 'application/json'
        }
      ) do |builder|
        builder.request :authorization, :basic,
                        vendor_credentials.client_id,
                        vendor_credentials.client_secret
        builder.request :json
        builder.response :json
        builder.response :logger if Rails.env.development?
        builder.response :raise_error, include_request: true
      end
    end

    def vendor_credentials
      @vendor_credentials ||=
        if (credentials = Rails.application.credentials&.paypal&.presence)
          Struct::VendorConfig.new(
            base_url: ENV.fetch('PAYPAL_BASE_URL', credentials.base_url),
            client_id: ENV.fetch('PAYPAL_CLIENT_ID', credentials.client_id),
            client_secret: ENV.fetch('PAYPAL_CLIENT_SECRET', credentials.client_secret)
          )
        end
    end
  end
end
