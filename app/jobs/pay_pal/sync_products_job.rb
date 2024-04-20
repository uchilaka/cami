# frozen_string_literal: true

require 'faraday'

module PayPal
  # TODO: Refactor to a thor task (invoking that task here instead)
  #   runnable with: bin/thor lx-cli:paypal:sync_products
  class SyncProductsJob < AbstractJob
    def perform(*_args)
      response = connection.get('/v1/catalogs/products') do |req|
        req.options.params_encoder = Faraday::FlatParamsEncoder
        req.params = { page_size: 20 }
      end
      data = response.body
      records_to_save = []
      error_records = []
      # Links are for pagination
      _links, products = data.values_at('links', 'products')
      products.each do |product|
        sku, display_name, description, created_at, links = product.values_at(
          'id', 'name', 'description', 'create_time', 'links'
        )
        next if Product.exists?(sku: sku.downcase)

        new_record = Product.new(
          sku: sku.downcase,
          display_name:,
          description:,
          created_at:
        )
        new_record.links = links

        if new_record.valid?
          records_to_save << new_record
        else
          Rails.logger.error "Record with SKU #{new_record.sku} is invalid",
                             errors: new_record.errors.full_messages
          ap new_record.errors.full_messages
          error_records << new_record
        end
      end

      if error_records.any?
        Rails.logger.info "Found #{error_records.count} error records"
        ap error_records
      end

      Rails.logger.info "Found #{records_to_save.count} records to save"

      results = Product.transaction do
        records_to_save.map(&:save!)
      end

      Rails.logger.info "Saved #{results.count} records" if results.all?
      # Showing the last 10 records
      ap records_to_save.last(10).map(&:reload)
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} failed", message: e.message
    end
  end
end
