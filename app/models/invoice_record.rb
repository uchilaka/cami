# frozen_string_literal: true

# == Schema Information
#
# Table name: invoice_records
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  document_id :string           not null
#
# Indexes
#
#  index_invoice_records_on_document_id  (document_id) UNIQUE
#
class InvoiceRecord < ApplicationRecord
  resourcify

  def document
    Invoice.find(document_id)
  end
end
