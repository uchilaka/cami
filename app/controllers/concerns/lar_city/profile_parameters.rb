# frozen_string_literal: true

module LarCity
  module ProfileParameters
    extend ActiveSupport::Concern

    def compose_create_params(request_params)
      raise ArgumentError, 'request_params must be a Hash' unless request_params.is_a?(Hash)

      request_params
        .except(*(common_profile_params + individual_profile_params)).to_h.symbolize_keys
    end

    def business_profile_params
      common_profile_params
    end

    def individual_profile_params
      common_profile_params + %i[image_url family_name given_name]
    end

    def common_profile_params
      %i[phone email]
    end
  end
end
