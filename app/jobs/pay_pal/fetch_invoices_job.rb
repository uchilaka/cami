# frozen_string_literal: true

module PayPal
  # TODO: Works in tandem with invoice update webhooks to fetch invoices
  #   and keep invoicing data in sync with PayPal
  class FetchInvoicesJob < AbstractJob
    attr_accessor :enqueued_records, :error_records

    PAGE_LIMIT = 10

    def perform(*_args)
      @account_records = []
      @enqueued_records = []
      @error_records = []
      # TODO: Calculate the page number to start fetching from based on
      #   the number of invoice records in the database
      page = 1
      start_page = page
      next_link = fetch(page:)
      while next_link && page < (start_page + PAGE_LIMIT)
        page += 1
        next_link = fetch(page:)
      end

      Rails.logger.info "Found #{enqueued_records.count} records to process"
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} failed: #{e.message}"
    end

    def fetch(page: 1)
      response = connection.get('/v2/invoicing/invoices') do |req|
        req.options.params_encoder = Faraday::FlatParamsEncoder
        req.params = { page_size: 25, page: }
      end
      data = response.body
      # Links are for pagination
      links, items = data.values_at('links', 'items')
      @enqueued_records += items
      return nil unless links.is_a?(Array)

      # Return next page link
      links.find { |link| link['rel'] == 'next' }
    end

    def process_record(record)
      vendor_record_id, status, detail, invoicer, primary_recipients,
        amount, due_amount, payments = record.values_at(
          'id', 'status', 'detail', 'invoicer', 'primary_recipients',
          'amount', 'due_amount', 'payments'
        )
      invoice_number, invoiced_at, viewed_by_recipient,
        currency_code, note = detail.values_at(
          'invoice_number', 'invoice_date', 'viewed_by_recipient',
          'currency_code', 'note'
        )
      due_at = detail.dig('payment_term', 'due_date')
      # Extract individual accounts
      primary_recipients.each do |recipient|
        given_name = recipient.dig('billing_info', 'name', 'given_name')
        family_name = recipient.dig('billing_info', 'name', 'surname')
        display_name = recipient.dig('billing_info', 'name', 'full_name')
        email = recipient.dig('billing_info', 'email_address')
        @account_records << {
          given_name:, family_name:, display_name:,
          email:, type: 'Individual'
        }
        business_name = recipient.dig('billing_info', 'business_name')
        next unless business_name.present?

        @account_records << { display_name: business_name, type: 'Business' }
      end
    end
  end
end
