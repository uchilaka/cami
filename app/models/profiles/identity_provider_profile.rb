# frozen_string_literal: true

module Profiles
  class IdentityProviderProfile
    include ActiveModel::API
    include ActiveModel::Serialization
    extend ActiveModel::Callbacks
    include ActiveModel::Dirty

    attr_accessor :email,
                  :provider_name,
                  :given_name,
                  :family_name,
                  :display_name,
                  :image_url,
                  :confirmation_sent_at,
                  :verified

    def attributes
      {
        email: nil,
        provider_name: nil,
        given_name: '',
        family_name: '',
        display_name: nil,
        image_url: nil,
        confirmation_sent_at: nil,
        verified: false
      }
    end
  end
end
