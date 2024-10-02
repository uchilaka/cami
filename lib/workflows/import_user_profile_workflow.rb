# frozen_string_literal: true

class ImportUserProfileWorkflow
  include Interactor
  include InteractorInvoiceProcessing

  def call
    invoice, profile = nil
    invoice_account = context.invoice_account
    invoice = invoice_account.invoice
    require_invoice_record_presence!

    email, display_name, given_name, family_name =
      invoice_account.serializable_hash.values_at 'email', 'display_name', 'given_name', 'family_name'
    display_name = email if display_name.blank?

    if email.blank?
      context.errors << I18n.t('workflows.import_user_profile.errors.email_required')
      context.fail!(message: context.errors.last)
      return
    end

    if given_name.blank? && family_name.blank?
      context.errors << I18n.t('workflows.import_user_profile.errors.name_required')
      context.fail!(message: context.errors.last)
      return
    end

    # Create a profile for the contact and capture data that
    # can be claimed by the user(s) when they sign up
    provider = invoice.payment_vendor
    profile = Metadata::Profile.find_by("vendor_data.#{provider}.email": email)
    if profile.present?
      # TODO: Link this profile to the invoice
      context.fail!(message: I18n.t('workflows.import_user_profile.errors.already_exists'))
      return
    end

    # Create a new orphaned profile that can be claimed by the user when they sign up
    vendor_data = { "#{provider}": { email:, display_name:, given_name:, family_name: } }.symbolize_keys
    profile = Metadata::Profile.new(vendor_data:)

    # Business accounts can be matched to a user profile by the email address.
    # Individual accounts MUST be linked by setting the account_id on the user profile.
    if context.account.present? && context.account.is_a?(Individual)
      # Link the provided account record
      profile.account_id = context.account.id
    end
    profile.save!
  rescue LarCity::Errors::InvalidInvoiceDocument => e
    context.fail!(message: e.message)
  ensure
    context.invoice = invoice
    context.profile = profile
  end
end
