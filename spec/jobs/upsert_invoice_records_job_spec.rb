# frozen_string_literal: true

require 'rails_helper'

# Refactoring? Review sidekiq testing documentation:
# https://github.com/sidekiq/sidekiq/wiki/Testing
RSpec.describe UpsertInvoiceRecordsJob, type: :job do
  let(:invoice_data) { YAML.load_file('spec/fixtures/paypal/fetch_invoices_sanitized.yml') }
  let(:items) { invoice_data['items'] }

  before do
    dataset = items.map { |data| InvoiceDocumentSerializer.new(data).serializable_hash }
    # Batch create all invoice records
    Invoice.create(dataset)
  end

  describe '#perform' do
    it 'creates new account records' do
      expect { described_class.perform_now }.to change(Account, :count).by(10)
    end
  end
end
