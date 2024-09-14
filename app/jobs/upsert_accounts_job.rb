# frozen_string_literal: true

class UpsertAccountsJob < ApplicationJob
  queue_as :whenever

  BATCH_LIMIT = 10

  def perform
    Invoice
      .where(updated_accounts_at: nil)
      .where.not(status: %w[CANCELED REFUNDED])
      .each do |invoice|
      next if invoice.accounts.none?

      Rails.logger.info "Found accounts for #{invoice.id}", accounts: invoice.accounts
      invoice.accounts.each do |account|
        if (accounts = lookup_accounts(account))
          Rails.logger.warn("Found matching account(s) for #{account['email']}", accounts:)
          next
        end
        new_account = Account.new(account)
        new_account.display_name ||= new_account.email
        new_account.save!
        Rails.logger.info "Created account #{account['id']} from invoice #{invoice.id}", account: new_account
        new_account.add_role(:customer, invoice.record) if invoice.record.present?
      end
    end
  end

  private

  def lookup_accounts(params)
    params = params.symbolize_keys
    if params[:email].present?
      Account.where(email: params[:email], type: params[:type])
    else
      Account.where(display_name: params[:display_name], type: params[:type])
    end
  end
end
