# frozen_string_literal: true

module Zoho
  module API
    class Account < Model
      @@resource_url ||= nil

      class << self
        def upsert(record)
          access_token = AccessToken.generate['access_token']
          resource_uri = "/crm/v7/#{module_name}/upsert"
          payload = {
            data: [
              Zoho::AccountSerializer.new(record).serializable_hash
            ],
            duplicate_check_fields: %w[Email Mobile],
            trigger: ['workflow']
          }
          response = connection(access_token:).post(resource_uri, payload)
          response.body
        end

        def module_name
          name.to_s.split('::').last.pluralize.capitalize
        end

        def resource_url(auth: true)
          @@resource_url ||=
            unless @@resource_url.present?
              response = connection(auth:).get('/oauth/serverinfo')
              data = response.body || {}
              @@resource_url = data.dig('locations', 'us')
            end
        end

        def base_url(auth: false)
          return 'https://accounts.zoho.com' if auth

          super
        end
      end
    end
  end
end
