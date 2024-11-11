# frozen_string_literal: true

class UpsertUserFromOmniauthWorkflow
  include Interactor

  def call
    uid, provider = context.access_token.values_at('uid', 'provider')
    given_name, family_name, email, unverified_email, email_verified, image_url, verified =
      context.access_token.info.values_at(
        'first_name', 'last_name', 'email', 'unverified_email', 'email_verified', 'image', 'verified'
      )
    user = User.find_by(email:)
    user ||= User.new(
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
    provider_profile =
      (user.identity_provider_profiles.find_by(provider: provider) if user.persisted?)
    provider_profile ||= IdentityProviderProfile.new(provider_profile_attrs)

    # Fail the account setup if an existing profile is found for this provider with a different UID
    context.fail!(message: 'Identity provider access token mismatch: UID') if provider_profile.uid != uid

    return unless context.success?

    User.transaction do
      # TODO: Update the customers array of providers after they are re-confirmed
      #   when a new auth provider is detected
      user.providers << provider unless user.providers.include?(provider)
      user.uids[provider] = uid if user.uids[provider].blank?
      # Barebones user profile setup to capture the profile image URL
      user.profile = UserProfile.new(image_url:) if user.profile.blank?
      user.save!
    end

    # Next, attempt to save the provider's profile for this user
    provider_profile.user ||= user
    provider_profile.save if provider_profile.changed?

    # All good?
    context.fail!(messages: provider_profile.errors.full_messages) \
      if provider_profile.errors.any?
  ensure
    context.user = user
    context.provider_profile = provider_profile
  end
end
