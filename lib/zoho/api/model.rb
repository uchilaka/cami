# frozen_string_literal: true

module Zoho
  module API
    class Model
      class << self
        def resource_url(args = {})
          raise NotImplementedError
        end

        def connection(auth: false, access_token: nil)
          url = base_url(auth:)
          Faraday.new(url:) do |builder|
            builder.request :authorization, 'Zoho-oauthtoken', access_token if access_token.present?
            builder.request :json
            builder.response :json
            builder.response :logger if Rails.env.development?
            builder.response :raise_error, include_request: true
          end
        end

        def base_url(_args = {})
          'https://www.zohoapis.com'
        end
      end
    end
  end
end
