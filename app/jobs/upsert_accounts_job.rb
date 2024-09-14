# frozen_string_literal: true

class UpsertAccountsJob < ApplicationJob
  queue_as :whenever

  BATCH_LIMIT = 10

  def perform
    Invoice
      .where(updated_accounts_at: nil)
      .each do |invoice|
      next if invoice.accounts.none?

      UpsertInvoiceRecords.call(invoice)
    end
  end
end
