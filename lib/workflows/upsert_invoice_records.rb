# frozen_string_literal: true

module Workflows
  class UpsertInvoiceRecords
    include Interactor

    def call
      invoice = context.invoice
      accounts = invoice.accounts
      return if accounts.none?

      # The syntax for transactions in Mongoid changes in version 9.0
      # https://www.mongodb.com/docs/mongoid/9.0/reference/transactions/
      # Current version is 8.1
      # https://www.mongodb.com/docs/mongoid/8.1/reference/transactions/
      invoice.with_session do |session|
        session.start_transaction
        Account.transaction do
          Rails.logger.info("Found accounts for #{invoice.id}", accounts:)
          accounts.each do |account|
            matching_accounts = lookup_accounts(account)
            if matching_accounts.any?
              Rails.logger.warn('Found matching account(s)', accounts: matching_accounts)
              next
            end
            display_name, email, type = account.values_at 'display_name', 'email', 'type'
            display_name ||= email
            new_account = Account.create(display_name:, type:)
            new_account.save!
            new_account.profile.update(email:) if new_account.is_a?(Business)
            Rails.logger.info "Created account #{account['id']} from invoice #{invoice.id}", account: new_account
            new_account.add_role(:customer, invoice.record) if invoice.record.present?
          end
          invoice.update(updated_accounts_at: Time.zone.now)
        end
      end
    end

    private

    def lookup_accounts(params)
      params = params.symbolize_keys
      if params[:email].present?
        # Check for a business
        record = Metadata::Business.find_by(email: params[:email])&.business
        return [record] if record.present?

        # Check for an individual account
        User.find_by(email: params[:email])&.accounts || []
      else
        filter_params = params.slice(:display_name, :type).reverse_merge(type: 'Business')
        Account.where(filter_params)
      end
    end
  end
end
