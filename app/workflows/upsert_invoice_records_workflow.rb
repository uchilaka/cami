# frozen_string_literal: true

class UpsertInvoiceRecordsWorkflow
  include Interactor
  include InteractorTimer
  include InteractorErrorHandling

  def call
    invoice = context.invoice
    accounts = invoice.metadata['accounts']
    return if accounts.none?

    raise LarCity::Errors::InvalidInvoiceRecord, I18n.t('models.invoice.errors.record_missing') \
      if invoice.blank?

    Account.transaction do
      Rails.logger.info("Found accounts for #{invoice.id}", accounts:)
      accounts.each do |invoice_account|
        account_result = ImportAccountWorkflow.call(invoice:, invoice_account:)

        unless account_result.success?
          context.errors += account_result.errors
          next
        end

        new_account = account_result.account

        Rails.logger.info(
          "Created account #{new_account.id} from invoice #{invoice.id}",
          account: new_account
        )
      end
      invoice.update(updated_accounts_at: Time.zone.now)
    end
  end
end