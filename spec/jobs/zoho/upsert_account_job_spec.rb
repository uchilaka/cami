# frozen_string_literal: true

require 'rails_helper'

module Zoho
  RSpec.describe UpsertAccountJob, type: :job do
    around do |example|
      Sidekiq::Testing.inline! { example.run }
    end

    context 'for business accounts' do
      let(:record) { Fabricate :business }

      context 'when a record is created' do
        it do
          expect { described_class.perform_async(record.id) }.to(change { record.reload.remote_crm_id })
        end
      end
    end
  end
end
