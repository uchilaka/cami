# frozen_string_literal: true

require 'awesome_print'
require 'faraday'

module PayPal
  # TODO: Refactor to a thor task (invoking that task here instead)
  #   runnable with: bin/thor lx-cli:paypal:sync_products
  class SyncProductsJob < ApplicationJob
    queue_as :yeet

    def perform(*_args)
      response = connection.get('/v1/catalogs/products')
      data = response.body
      records_to_save = []
      error_records = []

      handle_request_error(response) unless response.success?

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
          puts "Record with SKU #{new_record.sku} is invalid:"
          ap new_record.errors.full_messages
          error_records << new_record
        end
      end

      if error_records.any?
        puts "Found #{error_records.count} error records"
        ap error_records
      end

      puts "Found #{records_to_save.count} records to save"

      results = Product.transaction do
        records_to_save.map(&:save!)
      end

      puts "Saved #{results.count} records" if results.all?
      # Showing the last 10 records
      ap records_to_save.last(10).map(&:reload)
    end

    private

    def handle_request_error(response)
      data = response.body
      error_message =
        if data['error'].present?
          "Failed to fetch products: #{data['error']}"
        else
          'Failed to fetch products'
        end
      # Do something else
      raise Errors::IntegrationRequestFailed.new(
        error_message,
        status: response.status,
        vendor: 'PayPal'
      )
    end

    def connection
      @connection ||= Faraday.new(
        url: vendor_credentials.base_url,
        headers: {
          'Content-Type': 'application/json'
        }
      ) do |builder|
        builder.request :authorization, :basic,
                        vendor_credentials.client_id,
                        vendor_credentials.client_secret
        builder.request :json
        builder.response :json
        builder.response :logger if Rails.env.development?
      end
    end

    def vendor_credentials
      @vendor_credentials ||=
        if (credentials = Rails.application.credentials&.paypal&.presence)
          Struct::VendorConfig.new(
            base_url: ENV.fetch('PAYPAL_BASE_URL', credentials.base_url),
            client_id: ENV.fetch('PAYPAL_CLIENT_ID', credentials.client_id),
            client_secret: ENV.fetch('PAYPAL_CLIENT_SECRET', credentials.client_secret)
          )
        end
    end
  end
end
