# frozen_string_literal: true

class UpdateUserProfileWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # (profile_params:, current_user:, account:)
  def call
    current_user = context.current_user
    profile = current_user.profile || {}
    profile.reverse_merge!(UserProfile.new)
    profile_params =
      (context.profile_params.slice(*individual_profile_param_keys) if context.profile_params.present?)

    return unless profile_params.present?

    # TODO: Improve this logic to allow for updating the email address on
    #   a profile if a User does not exist for it - otherwise, profile emails
    #   should ONLY be changed as a side-effect of a confirmed email update
    #   to the associated account's email.
    _updated_email = profile_params.delete(:email) unless current_user.admin?
    input_number = profile_params.delete(:phone)
    profile_params[:phone] = PhoneNumber.new(value: input_number) if input_number.present?
    current_user.update(profile: profile.merge(profile_params))
    context.fail!(message: current_user.errors.full_messages) if current_user.errors.any?
  ensure
    context.current_user = current_user.reload
  end
end