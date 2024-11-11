# frozen_string_literal: true

class UpsertAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (params:, current_user:, account_params:, profile_params:)
  def call
    create_params =
      if context.account_params.present?
        context.account_params
      elsif context.params.present?
        compose_create_params(context.params)
      end

    account = context.account || Account.new(create_params)
    account.metadata ||= {}
    profile_params =
      if context.profile_params.present?
        context
          .profile_params
          .to_h.symbolize_keys
      elsif context.params.present?
        context
          .params
          .slice(*business_profile_param_keys)
          .to_h.symbolize_keys
      end

    if profile_params.present?
      input_number = profile_params.delete(:phone)
      if input_number.present?
        phone_number = PhoneNumber.new(value: input_number, resource: account.metadata)
        phone_number.save
      end
      account.metadata = account.metadata.merge(profile_params)
    end

    account.save
    context.fail!(messages: account.errors.full_messages) if account.errors.any?
  ensure
    context.account = account
  end
end
