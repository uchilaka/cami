# frozen_string_literal: true

class UpdateAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (account:, account_params:, profile_params:)
  def call
    account = context.account
    account_params =
      (context.account_params.to_h.symbolize_keys if context.account_params.present?)
    if account_params.present?
      account_params = context.account_params.to_h.symbolize_keys
      account.update(account_params)
      context.fail!(message: account.errors.full_messages) if account.errors.any?
      context.account = account
    end

    return unless context.success?

    context.profile = account.profile
    context.profile ||=
      if account.is_a?(Business)
        Metadata::Business.new(account_id: account.id)
      elsif account.is_a?(Individual)
        Metadata::Profile.new(account_id: account.id)
      end
    profile_params =
      if context.profile_params.present?
        if account.is_a?(Business)
          context.profile_params.slice(*business_profile_param_keys)
        else
          context.profile_params.slice(*individual_profile_param_keys)
        end.to_h.symbolize_keys
      end

    return unless context.success? && profile_params.present? && context.profile.present?

    # TODO: Improve this logic to allow for updating the email address on
    #   a profile if a User does not exist for it - otherwise, profile emails
    #   should ONLY be changed as a side-effect of a confirmed email update
    #   to the associated account's email.
    _updated_email = profile_params.delete(:email) unless Current.user&.admin?
    input_number = profile_params.delete(:phone)
    profile_params[:phone] = PhoneNumber.new(value: input_number) if input_number.present?
    context.profile.update(profile_params)
    context.fail!(message: context.profile.errors.full_messages) if context.profile.errors.any?
  end
end
