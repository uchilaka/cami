# frozen_string_literal: true

class CreateInvoiceRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_records, id: :uuid do |t|
      t.string :document_id, null: false
      t.timestamps
    end

    add_index :invoice_records, :document_id, unique: true
  end
end
