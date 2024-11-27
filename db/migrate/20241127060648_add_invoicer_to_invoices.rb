# frozen_string_literal: true

# 20241127060648_add_invoicer_to_invoices.rb
class AddInvoicerToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :invoicer, :jsonb, default: {}
  end
end
