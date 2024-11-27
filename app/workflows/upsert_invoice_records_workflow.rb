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

    accounts.each do |invoice_account|
      ImportAccountWorkflow.call(invoice:, invoice_account:)
    end
  end
end
