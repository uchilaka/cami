# frozen_string_literal: true

require 'rails_helper'

module PayPal
  RSpec.describe FetchInvoicesJob, type: :job do
    around do |example|
      Sidekiq::Testing.inline! { example.run }
    end

    let(:paypal_bearer_token) do
      username = ENV.fetch('PAYPAL_CLIENT_ID')
      password = ENV.fetch('PAYPAL_CLIENT_SECRET')
      Base64.strict_encode64("#{username}:#{password}")
    end

    context 'when the request is authorized' do
      around do |example|
        # IMPORTANT: The `record: :once` option is used to prevent the cassette from being
        #  overwritten on subsequent test runs. If you need to update the cassette, change
        #  this option to `record: :new_episodes` and run the test once. Then revert the
        #  option back to `record: :once` to prevent the cassette from being overwritten.
        maybe_record_cassette(name: 'paypal/fetch_invoices', record: :once, tag: :obfuscate) do
          example.run
        end
      end

      it 'fetches invoices' do
        expect { described_class.perform_now }.to change { Invoice.count }.by(48)
      end
    end

    context 'when the request is unauthorized' do
      let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
      let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

      before do
        allow_any_instance_of(described_class).to receive(:connection) { conn }
        allow(Rails.logger).to receive(:error)
      end

      after do
        allow_any_instance_of(described_class).to receive(:connection).and_call_original
      end

      it 'the expected exception is handled' do
        stubs.get(%r{/v2/invoicing/invoices}) do
          raise Faraday::UnauthorizedError, 'Unauthorized'
        end

        described_class.perform_now
        expect(Rails.logger).to have_received(:error).with(/failed/, { message: 'Unauthorized' })
      end
    end
  end
end
