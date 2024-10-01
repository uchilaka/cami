# frozen_string_literal: true

class UpsertInvoiceRecordsWorkflow
  include Interactor
  include InteractorTimer
  include InteractorErrorHandling

  def call
    invoice = context.invoice
    accounts = invoice.accounts
    return if accounts.none?

    raise LarCity::Errors::InvalidInvoiceDocument, I18n.t('models.invoice.errors.record_missing') \
      if invoice.record.blank?

    # The syntax for transactions in Mongoid changes in version 9.0
    # https://www.mongodb.com/docs/mongoid/9.0/reference/transactions/
    # Current version is 8.1
    # https://www.mongodb.com/docs/mongoid/8.1/reference/transactions/
    invoice.with_session do |_session|
      # TODO: To implement transactions in Mongoid, we will need to setup replica sets
      #   for local and test environments
      session.start_transaction if Flipper.enabled?(:feat__document_transactions)
      Account.transaction do
        Rails.logger.info("Found accounts for #{invoice.id}", accounts:)
        accounts.each do |invoice_account|
          account_result = ImportAccountWorkflow.call(invoice_account:)

          unless account_result.success?
            context.errors += account_result.errors
            next
          end

          profile_result = ImportUserProfileWorkflow.call(invoice_account:, account: account_result.account)
          unless profile_result.success?
            context.errors += profile_result.errors
            next
          end

          next unless account_result.success? && profile_result.success?

          Rails.logger.info(
            "Created account #{invoice_account.id} from invoice #{invoice.id}",
            account: account_result.account
          )
        end
        invoice.update(updated_accounts_at: Time.zone.now)
      end
    end
  end

  private

  def lookup_accounts(params)
    working_params = params.symbolize_keys
    if working_params[:email].present?
      # Check for a business account
      record = Metadata::Business.find_by(email: working_params[:email])&.business
      return [record] if record.present?

      # Check for accounts linked to a user via the invoice email address
      User.find_by(email: working_params[:email])&.accounts || []
    else
      filter_params = working_params.slice(:display_name, :type).reverse_merge(type: 'Business')
      Account.where(filter_params)
    end
  end
end
