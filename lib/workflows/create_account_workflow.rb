# frozen_string_literal: true

class CreateAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (params:)
  def call
    account = Account.new(compose_create_params(context.params))
    profile_params =
      if account.is_a?(Business)
        context.params.slice(*business_profile_params)
      else
        context.params.slice(*individual_profile_params)
      end.to_h.symbolize_keys
    account.save
    context.fail!(message: account.errors.full_messages) if account.errors.any?
    if context.success? && profile_params.present? && account.profile.present?
      input_number = profile_params.delete(:phone)
      profile_params[:phone] = PhoneNumber.new(value: input_number) if input_number.present?
      account.profile.update(profile_params)
      context.fail!(message: account.profile.errors.full_messages) if account.profile.errors.any?
    end
    context.account = account
    context.profile = account.profile
  end
end
