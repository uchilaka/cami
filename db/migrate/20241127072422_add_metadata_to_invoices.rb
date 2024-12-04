# frozen_string_literal: true

# 20241127072422_add_metadata_to_invoices.rb
class AddMetadataToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :metadata, :jsonb, default: {}
  end
end
