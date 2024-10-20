# frozen_string_literal: true

class UpdateAccountWorkflow
  include Interactor
  include LarCity::ProfileParameters

  # TODO: Include asserting the authorized account
  #   via Current.user
  # (account:, params:)
  def call
    account = context.account
    profile_params =
      if account.is_a?(Business)
        context.params.slice(*business_profile_params)
      else
        context.params.slice(*individual_profile_params)
      end.to_h.symbolize_keys
    profile_params.to_h.symbolize_keys!
    account.save
    if account.errors.any?
      context.fail!(message: account.errors.full_messages)
    else
      if account.profile.present? && profile_params.present?
        input_number = profile_params.delete(:phone)
        if input_number.present?
          parsed_number = PhoneNumber.new(value: input_number)
          if parsed_number.valid?
            account.profile.phone = parsed_number
          else
            account.profile.errors.add(:phone, parsed_number.errors.full_messages.join(', '))
          end
        end
        account.profile.update(profile_params)
      end
      account.profile.save if account.profile.changed?
      context.fail!(message: account.profile.errors.full_messages) if account.profile.errors.any?
    end
    context.account = account
    context.profile = account.profile
  end
end
