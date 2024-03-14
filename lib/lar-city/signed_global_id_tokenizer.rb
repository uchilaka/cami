# frozen_string_literal: true

module LarCity
  class SignedGlobalIdTokenizer
    class << self
      def encode(resource, expires_in: nil, purpose: 'sharing')
        options = {}
        options[:expires_in] = expires_in.to_i if expires_in
        options[:for] = purpose if purpose
        resource.to_signed_global_id(**options)
      end

      def decode(token, resource_class, includes: [])
        options = { only: resource_class }
        options[:includes] = includes unless includes.blank?
        GlobalID::Locator.locate_signed(token, **options)
      end
    end
  end
end
