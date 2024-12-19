# frozen_string_literal: true

# 20241127055712_add_types_to_invoices.rb
class AddTypesToInvoices < ActiveRecord::Migration[7.2]
  def change
    add_column :invoices, :type, :string, default: 'Invoice'
  end
end
