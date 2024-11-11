# frozen_string_literal: true

module LarCity
  module ProfileParameters
    extend ActiveSupport::Concern

    def compose_create_params(request_params)
      raise ArgumentError, 'request_params must be a Hash' \
        unless supported_input?(request_params)

      request_params
        .except(*(common_profile_param_keys + individual_profile_param_keys)).to_h.symbolize_keys
    end

    def supported_input?(params)
      return true if params.is_a?(ActionController::Parameters)
      return true if params.is_a?(Hash)

      false
    end

    def business_profile_param_keys
      common_profile_param_keys - %i[email]
    end

    def individual_profile_param_keys
      common_profile_param_keys + %i[image_url family_name given_name]
    end

    def common_profile_param_keys
      %i[phone email country_alpha2]
    end
  end
end
