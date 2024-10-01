# frozen_string_literal: true

module InteractorInvoiceProcessing
  extend ActiveSupport::Concern

  included do
    raise "#{name} requires Interactor" unless include?(Interactor)

    before do
      context.errors = []
      context.invoice = context.invoice_account&.invoice
    end

    def require_invoice_record_presence!
      invoice = context.invoice
      return unless invoice&.record.blank?

      invoice.errors.add :record, I18n.t('models.invoice.errors.record_missing', label: 'reference for invoice')
      context.errors += invoice.errors.full_messages
      raise LarCity::Errors::InvalidInvoiceDocument, invoice.errors.messages[:record]
    end
  end
end
