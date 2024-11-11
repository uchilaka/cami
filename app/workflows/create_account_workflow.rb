# frozen_string_literal: true

class CreateAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (params:, account_params:, profile_params:, current_user:)
  def call
    create_params = compose_create_params(context.params)
    account = Account.new(create_params)
    profile_params =
      context
        .params
        .slice(*business_profile_param_keys)
        .to_h.symbolize_keys
    account.save
    context.fail!(messages: account.errors.full_messages) if account.errors.any?

    if context.success? && profile_params.present?
      input_number = profile_params.delete(:phone)
      profile_params[:phone] = PhoneNumber.new(value: input_number) if input_number.present?
      if account.profile.present?
        context.profile = account.profile
      elsif account.is_a?(Individual)
        profile_params[:account_id] = account.id.to_s
        context.profile = Metadata::Profile.new(profile_params)
      end
      context.profile.update(profile_params)
      context.fail!(messages: context.profile.errors.full_messages) if context.profile.errors.any?
    end
    context.account = account
  end
end
