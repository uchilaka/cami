# 20241111062944_create_invoices.rb
class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices, id: :uuid do |t|
      t.belongs_to :invoiceable, polymorphic: true, type: :uuid
      t.jsonb :payments
      t.jsonb :links
      # t.timestamp :viewed_by_recipient_at # TODO Figure out queries of paper_trail data instead for this
      t.timestamp :updated_accounts_at
      t.string :invoice_number
      t.integer :status
      t.timestamp :issued_at
      t.timestamp :due_at
      t.timestamp :paid_at
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :due_amount, precision: 10, scale: 2
      t.string :currency_code
      t.text :notes

      t.timestamps
    end

    add_index :invoices, %i[invoiceable_type invoiceable_id]
  end
end
