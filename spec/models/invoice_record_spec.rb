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
require 'rails_helper'

RSpec.describe InvoiceRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
