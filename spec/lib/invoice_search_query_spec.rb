# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceSearchQuery do
  let(:qs) { nil }
  let(:params) { {} }

  subject { described_class.new(qs, params:) }

  context 'filtering by status and sort by descending due date' do
    let(:params) do
      {
        'f' => [{ 'field' => 'status', 'value' => 'PAID' }],
        's' => [{ 'field' => 'dueAt', 'direction' => 'desc' }]
      }.with_indifferent_access
    end

    it { expect(subject.predicates).to match(status_eq: 'PAID') }
    it { expect(subject.sorters).to include('due_at desc') }
  end

  context 'filtering by status and sort by descending due date (hash inputs)' do
    let(:params) do
      {
        'f' => { 'status' => 'PAID' },
        's' => { 'dueAt' => 'desc' }
      }.with_indifferent_access
    end

    it { expect(subject.predicates).to match(status_eq: 'PAID') }
    it { expect(subject.sorters).to include('due_at desc') }
  end
end
