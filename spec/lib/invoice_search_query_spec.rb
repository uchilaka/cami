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

  shared_examples 'search filtering by status and sorting by due date (with array of hashes inputs)' do |qs, status, expected_predicates|
    let(:params) do
      {
        'mode' => 'array',
        'q' => qs,
        'f' => [{ 'field' => 'status', 'value' => status.upcase }],
        's' => [{ 'field' => 'dueAt', 'direction' => 'desc' }]
      }
    end

    subject do
      filtered_params =
        ActionController::Parameters.new(params).permit(:q, :mode, f: %i[field value], s: %i[field direction])
      described_class.new(qs, params: filtered_params)
    end

    it { expect(subject.predicates).to match(expected_predicates) }
    it { expect(subject.sorters).to include('due_at desc') }
  end

  shared_examples 'search filtering by status and sorting by due date' do |qs, status, expected_predicates|
    let(:params) do
      {
        'q' => qs,
        'f' => { 'status' => status.upcase },
        's' => { 'dueAt' => 'desc' }
      }
    end

    subject do
      filtered_params =
        ActionController::Parameters.new(params).permit(:q, :mode, f: {}, s: {})
      described_class.new(qs, params: filtered_params)
    end

    it { expect(subject.predicates).to match(expected_predicates) }
    it { expect(subject.sorters).to include('due_at desc') }
  end

  context 'without query string' do
    it_should_behave_like 'search filtering by status and sorting by due date (with array of hashes inputs)',
                          nil, 'PAID', { status_eq: 'paid' }
    it_should_behave_like 'search filtering by status and sorting by due date',
                          nil, 'SENT', { status_eq: 'sent' }
  end

  context 'with query string' do
    it_should_behave_like 'search filtering by status and sorting by due date (with array of hashes inputs)',
                          'logistics', 'PAID',
                          {
                            'invoiceable_of_Account_type_display_name_or_invoiceable_of_Account_type_email_cont' => 'logistics',
                            :status_eq => 'paid'
                          }
    it_should_behave_like 'search filtering by status and sorting by due date',
                          'logistics', 'SENT',
                          {
                            'invoiceable_of_Account_type_display_name_or_invoiceable_of_Account_type_email_cont' => 'logistics',
                            :status_eq => 'sent'
                          }
  end
end
