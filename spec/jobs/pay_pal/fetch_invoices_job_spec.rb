# frozen_string_literal: true

require 'rails_helper'

module PayPal
  RSpec.describe FetchInvoicesJob, type: :job do
    around do |example|
      Sidekiq::Testing.inline! { example.run }
    end

    let(:client_id) { ENV.fetch('PAYPAL_CLIENT_ID', nil) }
    let(:client_secret) { ENV.fetch('PAYPAL_CLIENT_SECRET', nil) }
    let(:paypal_bearer_token) do
      Base64.strict_encode64("#{client_id}:#{client_secret}") \
        if client_id.present? && client_secret.present?
    end

    let(:cassette) { vcr_cassettes[:paypal] }

    context 'when the request is authorized' do
      around do |example|
        # IMPORTANT: The `record: :once` option is used to prevent the cassette from being
        #  overwritten on subsequent test runs. If you need to update the cassette, change
        #  this option to `record: :new_episodes` and run the test once. Then revert the
        #  option back to `record: :once` to prevent the cassette from being overwritten.
        VCR.use_cassette('paypal/fetch_invoices', cassette[:options]) do
          with_paypal_api_credentials { example.run }
        end
      end

      it 'fetches invoices' do
        expect { described_class.perform_now }.to change { Invoice.count }.by(48)
      end
    end

    context 'when the request is unauthorized' do
      # TODO: Is there a way to stub the connection more concisely i.e. with the expected
      #   request parameters (uri in particular)?
      let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
      let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

      before do
        allow_any_instance_of(described_class).to receive(:connection) { conn }
        allow(Rails.logger).to receive(:error)
      end

      around do |example|
        with_paypal_api_credentials { example.run }
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
