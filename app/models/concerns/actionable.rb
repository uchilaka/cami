# frozen_string_literal: true

module Actionable
  extend ActiveSupport::Concern

  # require implementation of supported_actions method
  included do |base|
    extend ClassMethods
    include Rails.application.routes.url_helpers
    include InstanceMethods

    raise StandardError, "#{base.name} must be descended from ActiveRecord::Base" \
      unless base.ancestors.include?(ActiveRecord::Base)

    raise NotImplementedError, "#{name}.supported_actions method MUST be implemented" \
      unless base.respond_to?(:supported_actions)
  end

  module ClassMethods
    def available_actions
      @available_actions ||= %i[show edit new create update destroy back]
    end

    def supported_actions(*actions)
      invalid_values = actions - available_actions
      raise ArgumentError, "#{name}.supported_actions must return an array with valid values" \
        unless invalid_values.none?

      self.define_method(:supported_actions) do
        actions.presence || []
      end
    end
  end

  module InstanceMethods
    def resources_url(*args)
      case self.class
      when Invoice
        invoices_url(args)
      when Account
        accounts_url(args)
      else
        raise StandardError, 'Unsupported resource'
      end
    end

    def resource_url(resource, args = {})
      case self.class
      when Invoice
        invoice_url(resource, **args)
      when Account
        account_url(resource, **args)
      else
        raise StandardError, 'Unsupported resource'
      end
    end

    def modal_actions(resource)
      resource_name = resource.class.name.to_s || 'resource'
      {
        edit: {
          dom_id: SecureRandom.uuid,
          http_method: 'GET',
          label: 'Edit',
          url: resource_url(resource)
        },
        delete: {
          dom_id: SecureRandom.uuid,
          http_method: 'DELETE',
          label: 'Delete',
          url: resource_url(resource, format: :json)
        },
        back: {
          dom_id: SecureRandom.uuid,
          http_method: 'GET',
          label: "Back to #{resource_name.pluralize}",
          url: resources_url
        }
      }
    end
  end
end
