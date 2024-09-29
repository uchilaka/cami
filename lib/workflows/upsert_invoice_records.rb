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
      invoice.with_session do |_session|
        # TODO: To implement transactions in Mongoid, we will need to setup replica sets
        #   for local and test environments
        session.start_transaction if Flipper.enabled?(:feat__document_transactions)
        Account.transaction do
          Rails.logger.info("Found accounts for #{invoice.id}", accounts:)
          accounts.each do |account|
            matching_accounts = lookup_accounts(account.serializable_hash)
            if matching_accounts.any?
              Rails.logger.warn('Found matching account(s)', accounts: matching_accounts)
              # TODO: Handle single vs. multiple accounts matching invoice data
              if Flipper.enabled?(:feat__match_accounts_to_invoice_data)
                matching_accounts.each do |matching_account|
                  matching_account.add_role(:contact, invoice.record) if invoice.record.present?
                  matching_account.add_role(:customer, invoice.record) if matching_account.is_a?(Business)
                end
              end
              next
            end
            email, display_name, given_name, family_name, type =
              account.serializable_hash.values_at 'email', 'display_name', 'given_name', 'family_name', 'type'
            display_name = email if display_name.blank?

            # Create an account for the business
            new_account = Account.create(display_name:, type:)
            if invoice.record.present?
              new_account.add_role(:contact, invoice.record)
              new_account.add_role(:customer, invoice.record) if new_account.is_a?(Business)
            end

            if email.present?
              if given_name || family_name
                # Create a profile for the contact and capture data that
                # can be claimed by the user(s) when they sign up
                provider = invoice.payment_vendor
                profile = Metadata::Profile.find_by("vendor_data.#{provider}.email": email)
                if profile.blank?
                  # Create a new orphaned profile that can be claimed by the user when they sign up
                  vendor_data = { "#{provider}": { email:, display_name:, given_name:, family_name: } }
                  Metadata::Profile.create(vendor_data:)
                end
              end
              # Store the email address against the business account
              # (to help with data reconciliation later on)
              new_account.profile.update(email:)
            end
            new_account.save!
            Rails.logger.info "Created account #{account['id']} from invoice #{invoice.id}", account: new_account
          end
          invoice.update(updated_accounts_at: Time.zone.now)
        end
      end
    end

    private

    def lookup_accounts(params)
      working_params = params.symbolize_keys
      if working_params[:email].present?
        # Check for a business account
        record = Metadata::Business.find_by(email: working_params[:email])&.business
        return [record] if record.present?

        # Check for accounts linked to a user via the invoice email address
        User.find_by(email: working_params[:email])&.accounts || []
      else
        filter_params = working_params.slice(:display_name, :type).reverse_merge(type: 'Business')
        Account.where(filter_params)
      end
    end
  end
end
