# frozen_string_literal: true

module Zoho
  module Credentials
    def self.client_id
      ENV.fetch('ZOHO_CLIENT_ID', Rails.application.credentials&.zoho&.client_id)
    end

    def self.client_secret
      ENV.fetch('ZOHO_CLIENT_SECRET', Rails.application.credentials&.zoho&.client_secret)
    end
  end

  class AccessToken
    class << self
      def generate
        response = API::Account.connection.get(resource_url) do |req|
          req.options.params_encoder = Faraday::FlatParamsEncoder
          req.params = {
            client_id: Credentials.client_id,
            client_secret: Credentials.client_secret,
            grant_type: 'client_credentials',
            scope: supported_scopes.join(','),
            soid: ENV.fetch('CRM_ORG_ID')
          }
        end
        response.body
      end

      # Docs on scopes: https://www.zoho.com/crm/developer/docs/api/v7/scopes.html
      def supported_scopes
        %w[
          ZohoCRM.modules.accounts
          ZohoCRM.modules.appointments
          ZohoCRM.modules.contacts
          ZohoCRM.modules.deals
          ZohoCRM.modules.invoices
          ZohoCRM.modules.leads
          ZohoCRM.modules.notes
          ZohoCRM.modules.products
          ZohoCRM.modules.tasks
          ZohoCRM.modules.vendors
          ZohoCRM.users.READ
        ]
      end

      def resource_url
        "#{API::Account.resource_url}/oauth/v2/auth"
      end

      def client_id
        Rails.application.credentials&.zoho&.client_id
      end

      def client_secret
        Rails.application.credentials&.zoho&.client_secret
      end
    end
  end
end
