# frozen_string_literal: true

class CreateAccountWorkflow
  include Interactor

  def call
    create_params =
      context.params.except(*(business_profile_params + individual_profile_params)).to_h.symbolize_keys
    account = Account.new(create_params)
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
      account.profile.update(profile_params) if account.profile.present? && profile_params.present?
      account.profile.save if account.profile.changed?
      context.fail!(message: account.profile.errors.full_messages) if account.profile.errors.any?
    end
    context.account = account
    context.profile = account.profile
  end

  private

  def business_profile_params
    common_profile_params + %i[email]
  end

  def individual_profile_params
    common_profile_params + %i[image_url]
  end

  def common_profile_params
    %i[phone]
  end
end
