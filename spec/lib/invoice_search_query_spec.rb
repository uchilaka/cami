# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceSearchQuery do
  let(:qs) { nil }
  let(:params) { {} }

  subject do
    filtered_params =
      ActionController::Parameters.new(params).permit(:q, :mode, f: {}, s: {})
    described_class.new(qs, params: filtered_params)
  end

  context 'filtering by status and sort by descending due date (array of hashes inputs)' do
    let(:params) do
      {
        'mode' => 'array',
        'f' => [{ 'field' => 'status', 'value' => 'PAID' }],
        's' => [{ 'field' => 'dueAt', 'direction' => 'desc' }]
      }
    end

    subject do
      filtered_params =
        ActionController::Parameters.new(params).permit(:q, :mode, f: %i[field value], s: %i[field direction])
      described_class.new(qs, params: filtered_params)
    end

    it { expect(subject.predicates).to match(status_eq: 'PAID') }
    it { expect(subject.sorters).to include('due_at desc') }
  end

  context 'filtering by status and sort by descending due date' do
    let(:params) do
      {
        'f' => { 'status' => 'PAID' },
        's' => { 'dueAt' => 'desc' }
      }
    end

    it { expect(subject.predicates).to match(status_eq: 'PAID') }
    it { expect(subject.sorters).to include('due_at desc') }
  end
end
