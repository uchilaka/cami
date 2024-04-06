# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  family_name            :string
#  given_name             :string
#  nickname               :string
#  providers              :string           default([]), is an Array
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uids                   :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include MaintainsMetadata
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #
  # Source code for confirmable: https://github.com/heartcombo/devise/blob/main/lib/devise/models/confirmable.rb
  # Guide on adding confirmable: https://tommcfarlin.com/adding-confirmable-to-users-in-devise/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google]

  alias_attribute :first_name, :given_name
  alias_attribute :last_name, :family_name

  # Doc on name_of_person gem: https://github.com/basecamp/name_of_person
  has_person_name

  has_and_belongs_to_many :accounts

  def profile
    @profile ||= Metadata::Profile.find_or_initialize_by(user_id: id)
  end

  alias metadata profile


  def matching_auth_provider
    return nil if profile.blank?
    return nil if Current.auth_provider.blank?

    profile[Current.auth_provider.provider]
  end

  # https://github.com/heartcombo/devise?tab=readme-ov-file#active-job-integration
  # def send_devise_notification(notification, *args)
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end

  def initialize_profile
    if profile.present?
      profile.user_id ||= id
      profile.save if profile.changed? && profile.user.persisted?
    else
      Metadata::Profile.create(user_id: id)
    end
  end

  alias initialize_metadata initialize_profile

  class << self
    def from_omniauth(access_token = nil)
      access_token ||= Current.auth_provider
      uid = access_token.uid
      provider = access_token.provider
      given_name, family_name, email, image_url = access_token.info.values_at(
        'first_name', 'last_name', 'email', 'image'
      )
      user = User.find_by(email:)
      user ||= User.new(
        given_name:, family_name:, email:,
        password: Devise.friendly_token[0, 20]
      )

      transaction do
        # TODO: Update the customers array of providers after they are re-confirmed
        #   when a new auth provider is detected
        # user.providers << provider unless user.providers.include?(provider)
        user.uids[provider] = uid if user.uids[provider].blank?
        if user.save!
          # profile = Metadata::Profile.find_or_initialize_by(user_id: user.id)
          profile = user.profile
          profile.image_url = image_url
          profile[provider] = {
            **access_token.info,
            # TODO: This will no longer be needed when we implement
            #   Devise :confirmable in the User model.
            confirmation_sent_at: Time.now,
            # TODO: This will be used to keep track of whether this
            #   provider has been verified or not (via email, phone or TOTP)
            verified: false
          }
          profile.save!
        end
      end

      # TODO: Send confirmation request if current auth provider is not confirmed for the user
      # if !user.matching_auth_provider[:verified]
      #   user.confirmed_at = nil
      #   user.resend_confirmation_instructions
      #   user.save!
      # end

      # Returns either the user instance with errors or the persisted user record
      # TODO: Add a spec that asserts that when the transaction fails, a user instance
      #   with errors is returned
      user
    end
  end
end
