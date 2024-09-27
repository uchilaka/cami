# frozen_string_literal: true

require 'rails_helper'

module Workflows
  RSpec.describe UpsertInvoiceRecords do
    describe '.call' do
      context 'when there are no accounts' do
        pending 'does nothing'
      end

      context 'when there are accounts' do
        let(:invoice) { Fabricate(:invoice) }
        let(:account) { Fabricate(:account) }

        pending 'creates a new account'

        pending 'logs the account creation'

        pending 'adds the customer role to the invoice'
      end
    end
  end
end
