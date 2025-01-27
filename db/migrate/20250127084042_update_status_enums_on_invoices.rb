# frozen_string_literal: true

# 20250127084042_update_status_enums_on_invoices.rb
class UpdateStatusEnumsOnInvoices < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def up_only
    safety_assured do
      execute <<~SQL
        ALTER TYPE invoice_status
        ADD VALUE IF NOT EXISTS 'partially_paid'
        AFTER 'marked_as_paid';
      SQL

      execute <<~SQL
        ALTER TYPE invoice_status
        ADD VALUE IF NOT EXISTS 'cancelled'
        AFTER 'unpaid';
      SQL
    end
  end
end
