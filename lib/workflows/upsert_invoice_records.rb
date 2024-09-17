# frozen_string_literal: true

module Workflows
  class UpsertInvoiceRecords
    include Interactor

    def call
      return if context.accounts.none?

      Rails.logger.info "Found accounts for #{context.id}", accounts: context.accounts
      context.accounts.each do |account|
        matching_accounts = lookup_accounts(account)
        if matching_accounts.any?
          Rails.logger.warn('Found matching account(s)', accounts: matching_accounts)
          next
        end
        new_account = Account.new(account)
        new_account.display_name ||= new_account.email
        new_account.save!
        Rails.logger.info "Created account #{account['id']} from invoice #{invoice.id}", account: new_account
        new_account.add_role(:customer, context.record) if record.present?
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
end
