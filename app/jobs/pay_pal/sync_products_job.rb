# frozen_string_literal: true

require 'awesome_print'
require 'faraday'

module PayPal
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
      ap records_to_save

      # TODO: Failing with this weird error:
      #   ActiveModel::UnknownAttributeError: unknown attribute 'name' for Product.
      Product.create!(records_to_save) unless records_to_save.empty?
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
        url: vendor.base_url,
        headers: {
          'Content-Type': 'application/json'
        }
      ) do |builder|
        builder.request :authorization, :basic,
                        vendor.client_id,
                        vendor.client_secret
        builder.request :json
        builder.response :json
        builder.response :logger if Rails.env.development?
      end
    end

    def vendor
      @vendor ||= Rails.application.credentials.paypal
    end
  end
end
