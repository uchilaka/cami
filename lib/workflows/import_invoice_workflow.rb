# frozen_string_literal: true

class ImportInvoiceWorkflow
  include Interactor
  include InteractorTimer
  include InteractorErrorHandling

  # accounts:, invoice:
  def call
    # TODO: ingest invoice data imported from a payment vendor's system (e.g. Stripe or PayPal)
  end
end
