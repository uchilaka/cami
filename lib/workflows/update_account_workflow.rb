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

    context.profile = account.profile
    profile_params =
      if context.profile_params.present?
        if account.is_a?(Business)
          context.profile_params.slice(*business_profile_param_keys)
        else
          context.profile_params.slice(*individual_profile_param_keys)
        end.to_h.symbolize_keys
      end

    return unless context.success? && profile_params.present? && account.profile.present?

    input_number = profile_params.delete(:phone)
    profile_params[:phone] = PhoneNumber.new(value: input_number) if input_number.present?
    account.profile.update(profile_params)
    context.fail!(message: account.profile.errors.full_messages) if account.profile.errors.any?
    context.profile = account.profile
  end
end
