# frozen_string_literal: true

module Zoho
  module API
    class Account < Model
      @@resource_url ||= nil

      class << self
        def resource_url
          @@resource_url ||=
            unless @@resource_url.present?
              response = connection.get('/oauth/serverinfo')
              data = response.body || {}
              @@resource_url = data.dig('locations', 'us')
            end
        end

        def base_url
          'https://accounts.zoho.com'
        end
      end
    end
  end
end
