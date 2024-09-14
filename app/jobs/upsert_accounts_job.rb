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
      invoice.accounts.each do |account|
        if (accounts = Account.where(email: account['email'], type: account['type']))
          Rails.logger.warn("Found matching account(s) for #{account['email']}", accounts:)
        else
          new_account = Account.new(account)
          new_account
        end

        Rails.logger.info "Upserting account #{account['id']} for invoice #{invoice.id}"
        upsert_account(account)
      end
    end
  end
end
