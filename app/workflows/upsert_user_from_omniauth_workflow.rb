# frozen_string_literal: true

class UpsertUserFromOmniauthWorkflow
  include Interactor

  def call
    uid, provider = context.access_token.values_at('uid', 'provider')
    given_name, family_name, email, unverified_email, email_verified, image_url, verified =
      context.access_token.info.values_at(
        'first_name', 'last_name', 'email', 'unverified_email', 'email_verified', 'image', 'verified'
      )
    context.user = User.find_by(email:)
    context.user ||= User.new(
      given_name:, family_name:, email:,
      password: Devise.friendly_token[0, 20]
    )
    provider_profile_attrs = {
      email:,
      display_name: given_name,
      family_name:,
      given_name:,
      image_url:,
      metadata: {
        confirmation_sent_at: Time.now,
        unverified_email:,
        email_verified:
      },
      provider:,
      uid:,
      verified:
    }
    context.provider_profile =
      if context.user.persisted?
        context.user.identity_provider_profiles.find_by(provider: provider)
      else
        IdentityProviderProfile.new(provider_profile_attrs)
      end

    User.transaction do
      # TODO: Update the customers array of providers after they are re-confirmed
      #   when a new auth provider is detected
      context.user.providers << provider unless context.user.providers.include?(provider)
      # TODO: Figure out an alternative implementation so this isn't necessary
      context.user.providers = context.user.providers.uniq
      context.user.uids[provider] = uid if context.user.uids[provider].blank?
      context.user.profile = UserProfile.new(image_url:) if context.user.profile.blank?
      context.user.save!
    end

    # Next, attempt to save the provider's profile for this user
    context.provider_profile.user ||= user.reload
    context.provider_profile.save if context.provider_profile.changed?

    # All good?
    context.fail!(error: context.provider_profile.errors.full_messages) \
      if context.provider_profile.errors.any?
  end
end
