# frozen_string_literal: true

# 20240914130922_generate_invoice_records.rb
class GenerateInvoiceRecords < ActiveRecord::Migration[7.0]
  def up
    invoice_records = []
    document_updates = []
    Invoice.where(record_id: nil).map do |invoice|
      invoice_records << { document_id: invoice.id.to_s, created_at: invoice.created_at }
      document_updates << { id: invoice.id, record_id: invoice.id }
    end
    updated_records = InvoiceRecord.upsert_all(invoice_records, unique_by: :document_id, returning: %i[id document_id])
    bulk_invoice_updates = updated_records.map do |record|
      {
        update_one: {
          filter: { _id: BSON::ObjectId(record['document_id']) },
          # rubocop:disable Style/HashSyntax
          update: { :'$set' => { record_id: record['id'] } }
          # rubocop:enable Style/HashSyntax
        }
      }
    end
    Invoice.collection.bulk_write(bulk_invoice_updates, ordered: false)
  end

  def down
    Invoice.where.not(record_id: nil).update_all(record_id: nil)
    InvoiceRecord.destroy_all
  end
end
