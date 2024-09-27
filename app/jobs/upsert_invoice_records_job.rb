# frozen_string_literal: true

class UpsertInvoiceRecordsJob < ApplicationJob
  queue_as :whenever

  BATCH_LIMIT = 10

  def perform
    Invoice
      .where(updated_accounts_at: nil)
      .limit(BATCH_LIMIT)
      .each do |invoice|
      next if invoice.accounts.none?

      Workflows::UpsertInvoiceRecords.call(invoice:)
    end
  end
end
