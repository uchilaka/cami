# frozen_string_literal: true

class UpdateAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (account:, account_params:, profile_params:)
  def call
    account_params =
      (context.account_params.to_h.symbolize_keys if context.account_params.present?)
    return if account_params.blank?

    context.account.update(account_params)
    context.fail!(message: context.account.errors.full_messages) if context.account.errors.any?
  end
end
