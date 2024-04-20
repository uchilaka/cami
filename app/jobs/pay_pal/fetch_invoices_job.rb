# frozen_string_literal: true

module PayPal
  # TODO: Works in tandem with invoice update webhooks to fetch invoices
  #   and keep invoicing data in sync with PayPal
  class FetchInvoicesJob < AbstractJob
    attr_accessor :enqueued_records, :error_records

    PAGE_LIMIT = 10

    def perform(*_args)
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

      puts "Found #{enqueued_records.count} records to process"
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
      enqueued_records << items
      # Return next page link
      links.find { |link| link['rel'] == 'next' }
    end
  end
end
