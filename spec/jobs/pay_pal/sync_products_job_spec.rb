# frozen_string_literal: true

require 'rails_helper'

module PayPal
  RSpec.describe SyncProductsJob, type: :job do
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

    it 'syncs products' do
      # TODO: Make this less brittle - assert on specific records that are in the
      #   PayPal sandbox account (and/or VCR cassette)
      expect { described_class.perform_now }.to change { Product.count }.by(9).and \
        change { Metadata::Product.count }.by(9)
    end
  end
end
