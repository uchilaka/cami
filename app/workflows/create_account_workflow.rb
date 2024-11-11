# frozen_string_literal: true

class CreateAccountWorkflow
  include Interactor

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (params:, current_user:, account_params:, profile_params:)
  def call
    create_params =
      if context.account_params.present?
        context
          .account_params
          .to_h.symbolize_keys
          .slice(*self.class.allowed_parameter_keys)
      elsif context.params.present?
        context
          .params
          .to_h.symbolize_keys
          .slice(*self.class.allowed_parameter_keys)
      end

    # Support some initialization of the account happening outside of the workflow
    account = context.account
    # Ensure that we have an initialized account record
    account ||= Account.new
    # Assign the create params to the account
    account.assign_attributes(create_params)
    # Ensure that we have metadata initialized
    account.metadata ||= {}
    # Calculate profile params. This is a bit of a mess and should be refactored.
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

    # Save profile params to metadata
    account.metadata = account.metadata.merge(profile_params) \
      if profile_params.present?

    # Attempt to process the account phone number
    input_number = create_params.delete(:phone)
    if input_number.present?
      phone_number = PhoneNumber.new(value: input_number)
      if phone_number.valid?
        account.phone = phone_number.serializable_hash
      else
        account.errors.add(:phone, 'is invalid')
        context.fail!(messages: phone_number.errors.full_messages)
      end
    end

    return unless context.success?

    account.save
    context.fail!(messages: account.errors.full_messages) if account.errors.any?
  ensure
    context.account = account
  end

  class << self
    def allowed_parameter_keys
      %i[display_name status email slug tax_id phone metadata readme]
    end
  end
end
