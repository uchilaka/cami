# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PayPal::SyncProductsJob, type: :job do
  before do
    allow_any_instance_of(described_class).to receive(:vendor_credentials) do
      OpenStruct.new(
        base_url: 'https://api-m.paypal.com',
        client_id: ENV.fetch('PAYPAL_CLIENT_ID'),
        client_secret: ENV.fetch('PAYPAL_CLIENT_SECRET')
      )
    end
  end

  around do |example|
    Sidekiq::Testing.inline! do
      VCR.use_cassette(
        'paypal/sync_products',
        record: :new_episodes,
        re_record_interval: 3.months
      ) do
        example.run
      end
    end
  end

  # TODO: Make this insert 7 product records
  it 'syncs products' do
    expect { described_class.perform_now }.to change { Product.count }.by(7).and \
      change { Metadata::Product.count }.by(7)
  end
end
