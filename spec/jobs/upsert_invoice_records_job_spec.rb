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
    let(:batch_limit) { 25 }

    around do |example|
      with_modified_env(UPSERT_INVOICE_BATCH_LIMIT: batch_limit.to_s) { example.run }
    end

    context 'with incoming records within the batch limit' do
      let(:batch_limit) { 9_999 }

      it 'creates the expected tally of new account records' do
        expect { described_class.perform_now }.to change(Account, :count).by(23)
      end
    end

    context 'with incoming records exceeding the batch limit' do
      let(:batch_limit) { 5 }

      it 'creates new account records' do
        expect { described_class.perform_now }.to change(Account, :count).by(batch_limit)
      end
    end
  end
end