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

        def base_url(_args = {})
          'https://www.zohoapis.com'
        end

        def fields_list_url
          "https://crm.zoho.com/crm/org#{org_id}/settings/api/modules/#{module_name}?step=FieldsList"
        end

        def resource_url(args = {})
          raise NotImplementedError, "You must implement the #{name}.#{__method__} method"
        end

        protected

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
