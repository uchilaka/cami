# frozen_string_literal: true

# From :invoice_account set as a parameter on Context.call with:
# - :email
# - :display_name
# - :given_name
# - :family_name
# - :type
class ImportAccountWorkflow
  include Interactor
  def call
    account = nil
    invoice_account = context.invoice_account
    invoice = invoice_account.invoice
    raise LarCity::Errors::InvalidInvoiceDocument, I18n.t('models.invoice.errors.record_missing') \
      if invoice.record.blank?

    context.accounts = lookup(invoice_account.serializable_hash)

    if context.accounts.none?
      email, display_name, _given_name, _family_name, type =
        invoice_account.serializable_hash.values_at 'email', 'display_name', 'given_name', 'family_name', 'type'
      display_name = email if display_name.blank?

      # Create an account for the business
      account = Account.create(display_name:, type:)
      if account.persisted?
        account.add_role(:customer, invoice.record) if account.is_a?(Business)
        if email.present?
          account.add_role(:contact, invoice.record)
          account.profile.update(email:) if account.is_a?(Business)
        end
      else
        context.errors = account.errors.full_messages
        context.fail!(message: I18n.t('workflows.invoice_account.errors.generic'))
      end
    else
      context.fail!(message: I18n.t('workflows.invoice_account.errors.already_exists'))
    end
  rescue LarCity::Errors::InvalidInvoiceDocument => e
    context.fail!(message: e.message)
  ensure
    context.account = account
  end

  private

  # Returns a list of any matching account(s) found
  def lookup(params)
    working_params = params.symbolize_keys
    email, display_name, type = working_params.values_at(:email, :display_name, :type)
    if email.present?
      # Check for a business account
      record = Metadata::Business.find_by(email:)&.business
      return [record] if record.present?

      # Check for accounts linked to a user via the invoice email address
      User.find_by(email:)&.accounts || []
    else
      filter_params = { display_name:, type: }.reverse_merge(type: 'Business')
      Account.where(filter_params)
    end
  end
end
