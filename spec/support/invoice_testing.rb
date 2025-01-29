# frozen_string_literal: true

RSpec.shared_context 'for invoice testing', shared_context: :metadata do
  def sample_invoice_data
    @sample_invoice_data ||=
      YAML
        .load_file('spec/fixtures/paypal/fetch_invoices_sanitized.yml')
  end

  def sample_invoice_items
    sample_invoice_data['items']
  end

  def sample_invoice_dataset
    @sample_invoice_dataset ||= sample_invoice_items.map do |data|
      PayPal::InvoiceSerializer.new(data).serializable_hash
    end
  end

  def load_sample_invoice_dataset
    # Batch create all invoice records
    _results = Invoice.create!(sample_invoice_dataset)
    # Upsert all account records
    Sidekiq::Testing.inline! { UpsertInvoiceRecordsJob.perform_async }
  end
end
