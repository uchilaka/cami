# frozen_string_literal: true

module Zoho
  module API
    class Model
      @@connection ||= nil

      class << self
        def resource_url
          raise NotImplementedError
        end

        def connection(_auth: false)
          @@connection ||=
            unless @@connection.present?
              Faraday.new(
                url: base_url,
                headers: {
                  Accept: 'application/json'
                }
              ) do |builder|
                # if _auth
                #   builder.request :authorization, :basic,
                #                   Zoho::Credentials.client_id,
                #                   Zoho::Credentials.client_secret
                # end
                # builder.request :json
                builder.response :json
                builder.response :logger if Rails.env.development?
                builder.response :raise_error, include_request: true
              end
            end
        end

        def base_url
          'https://www.zohoapis.com'
        end
      end
    end
  end
end
