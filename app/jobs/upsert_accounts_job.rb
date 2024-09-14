# frozen_string_literal: true

class UpsertAccountsJob < ApplicationJob
  queue_as :whenever

  BATCH_LIMIT = 10

  def perform
    Invoice
      .where(updated_accounts_at: nil)
      .where.not(status: %w[CANCELED REFUNDED])
      .each do |invoice|
      Rails.logger.info "Found accounts for #{invoice.id}", accounts: invoice.accounts
    end
  end
end
