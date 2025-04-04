# frozen_string_literal: true

module Zoho
  module API
    class Account < Model
      # About class (instance) variables: https://www.ruby-lang.org/en/documentation/faq/8/
      @resource_url ||= nil

      class << self
        def upsert(record, pretend: false)
          access_token = AccessToken.generate['access_token']
          resource_uri = "/crm/v7/#{module_name}/upsert"
          payload = {
            data: [
              Zoho::AccountSerializer.new(record).serializable_hash
            ],
            duplicate_check_fields: %w[Email Phone],
            trigger: ['workflow']
          }
          if pretend
            Rails.logger.info("Pretending to upsert #{module_name} record data", payload:)
            return
          else
            Rails.logger.info('Upserting Zoho account record', id: record.id)
          end
          response = connection(access_token:).post(resource_uri, payload)
          result = response.body
          info = result.dig('data', 0)
          code, action = info&.values_at('code', 'action')
          if code == 'SUCCESS'
            remote_crm_id = info.dig('details', 'id')
            case action
            when 'insert', 'update'
              if record.update(remote_crm_id:)
                Rails.logger.info(
                  'Successfully upserted Zoho account record',
                  record: record.serializable_hash,
                  remote_crm_id:, action:
                )
              else
                Rails.logger.error(
                  'Failed to update Zoho account record',
                  record: record.serializable_hash,
                  remote_crm_id:, action:
                )
              end
            else
              Rails.logger.warn(
                "An unsupported action '#{action}' occurred against a Zoho account record",
                record: record.serializable_hash,
                action:, result:
              )
            end
          else
            Rails.logger.error(
              'Failed to upsert Zoho account record',
              record: record.serializable_hash,
              result:
            )
          end
          result
        end

        def resource_url(auth: true)
          return auth_endpoint_url if auth

          base_url(auth:)
        end

        def base_url(auth: false)
          return 'https://accounts.zoho.com' if auth

          super
        end

        def module_name
          name.to_s.split('::').last.pluralize.capitalize
        end
      end
    end
  end
end
