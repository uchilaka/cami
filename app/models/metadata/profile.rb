# frozen_string_literal: true

module Metadata
  class Profile
    include DocumentRecord
    include Mongoid::Attributes::Dynamic

    # References the individual account record that this profile is linked to
    field :account_id, type: String
    # References the user record that this profile is linked to
    field :user_id, type: String

    field :email, type: String
    field :family_name, type: String
    field :given_name, type: String

    # Identity providers
    field :google, type: Hash
    field :facebook, type: Hash
    field :apple, type: Hash
    field :whatsapp, type: Hash

    field :vendor_data, type: Hash

    field :image_url, type: String
    field :last_seen_at, type: Time, default: -> { Time.now }

    embeds_one :phone, class_name: 'PhoneNumber'

    validates :email, email: true, allow_nil: true
    # TODO: Figure out how to restrict the number of profiles per user
    #   to a maximum of one, but allow for the creation of orphaned
    #   profiles that can be claimed by a user (perhaps allow_blank config?
    #   need to assert with specs)
    validates :user_id, allow_blank: true, uniqueness: { case_sensitive: false }

    index({ user_id: 1 }, { name: 'user_profile__user_id_index' })
    index({ 'vendor_data.paypal.email': 1 }, { name: 'user_profile__paypal_email_index' })

    def user
      @user ||= User.find_by(id: user_id)
    end

    def account
      @account ||= Account.find_by(id: account_id)
    end

    def primary_profile
      user_id == user&.primary_profile_id
    end
  end
end
