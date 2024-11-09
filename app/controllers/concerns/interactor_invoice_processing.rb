# frozen_string_literal: true

module InteractorInvoiceProcessing
  extend ActiveSupport::Concern

  included do
    include InteractorErrorHandling

    raise "#{name} requires Interactor" unless include?(Interactor)

    before do
      context.invoice = context.invoice_account&.invoice
      context.metadata[:invoice_number] = context.invoice&.invoice_number
    end
  end

  # TODO: Can this just be declared in the module itself?
  def require_invoice_record_presence!
    invoice = context.invoice
    return unless invoice&.record.blank?

    invoice.errors.add :record, I18n.t('models.invoice.errors.record_missing', label: 'reference for invoice')
    context.errors += invoice.errors.full_messages
    raise LarCity::Errors::InvalidInvoiceDocument, invoice.errors.messages[:record]
  end
end
