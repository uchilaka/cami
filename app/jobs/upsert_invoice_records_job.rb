# frozen_string_literal: true

class UpsertInvoiceRecordsJob < ApplicationJob
  queue_as :whenever

  sidekiq_options retry: 3

  BATCH_LIMIT = 25

  def perform
    Invoice
      .where(updated_accounts_at: nil)
      .limit(batch_limit)
      .each do |invoice|
      next if invoice.metadata['accounts']&.none?

      UpsertInvoiceRecordsWorkflow.call(invoice:)
    end
  end

  def batch_limit
    ENV.fetch('UPSERT_INVOICE_BATCH_LIMIT', BATCH_LIMIT).to_i
  end
end