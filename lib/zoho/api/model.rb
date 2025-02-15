# frozen_string_literal: true

module Zoho
  module API
    class Model
      class << self
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

        def base_url(*)
          'https://www.zohoapis.com'
        end

        def auth_endpoint_url
          @auth_endpoint_url ||=
            if @auth_endpoint_url.blank?
              response = connection(auth: true).get('/oauth/serverinfo')
              data = response.body || {}
              url = data.dig('locations', 'us')
              raise ::LarCity::Errors::Unknown3rdPartyHostError unless valid_http_host?(url)

              url
            end
        end

        def fields_list_url
          "https://crm.zoho.com/crm/org#{org_id}/settings/api/modules/#{module_name}?step=FieldsList"
        end

        def resource_url(args = {})
          raise NotImplementedError, "You must implement the #{name}.#{__method__} method"
        end

        protected

        def valid_http_host?(url_or_hostname)
          hostname = URI.parse(url_or_hostname).host
          allowed_hosts.include?(hostname)
        end

        private

        def allowed_hosts
          @allowed_hosts ||=
            Rails
              .application
              .config_for(:allowed_3rd_party_hosts)
              .dig(:zoho, :by_region)
              .entries
              .map { |_r, host| host }
        end

        def module_name
          raise NotImplementedError, "You must implement the #{name}.#{__method__} method"
        end

        def org_id
          ENV.fetch('CRM_ORG_ID', Rails.application.credentials&.zoho&.org_id)
        end
      end
    end
  end
end
