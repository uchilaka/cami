# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PIIHelper do
  let!(:mock_class) { Class.new { extend PIIHelper } }

  describe '#replace_pii' do
    let(:value) { 'John Doe' }
    let(:key) { 'given_name' }

    subject { mock_class.replace_pii(key, value) }

    context 'with given_name' do
      it 'replaces the given name with a fake name' do
        expect(subject).not_to eq(value)
      end
    end

    context 'with name' do
      let(:value) { 'John Doe' }
      let(:key) { 'name' }

      it 'replaces the name with a fake name' do
        expect(subject).not_to eq(value)
      end
    end
  end

  describe '#sanitize_json' do
    let(:data) { {} }

    subject { mock_class.sanitize_json(data) }

    context 'with a hash' do
      let(:data) do
        {
          name: 'Paul Newman',
          given_name: 'Paul',
          first_name: 'Paul',
          family_name: 'Newman',
          last_name: 'Newman',
          surname: 'Newman',
          email: 'jdoe@hotmail.com',
          phone: '555-444-1234',
          full_address: '123 Main St, Anytown, USA'
        }
      end

      it 'sanitizes PII from JSON data' do
        expect(subject).not_to match(data)
      end
    end

    context 'with a more complex JSON structure' do
      let(:data) do
        {
          items: [
            {
              name: 'Paul Newman',
              given_name: 'Paul',
              first_name: 'Paul',
              family_name: 'Newman',
              last_name: 'Newman',
              surname: 'Newman',
              email: 'jdoe@hotmail.com',
              phone: '555-444-1234',
              full_address: '123 Main St, Anytown, USA'
            },
            {
              name: 'Mark Cuban',
              given_name: 'Mark',
              first_name: 'Mark',
              family_name: 'Cuban',
              last_name: 'Cuban',
              surname: 'Cuban',
              email: 'mcuban@bets.net',
              phone: '555-444-5678',
              full_address: '456 Elm St, SomeTown, USA'
            }
          ],
          "links": [
            {
              # TODO: Support obfuscating URLs
              "href": 'https://api.paypal.com/v2/invoicing/invoices?page=2&page_size=25&total_required=false',
              "rel": 'self',
              "method": 'GET'
            },
            {
              # TODO: Support obfuscating URLs
              "href": 'https://api.paypal.com/v2/invoicing/invoices?page=1&page_size=25&total_required=false',
              "rel": 'prev',
              "method": 'GET'
            }
          ]
        }
      end

      it 'sanitizes PII from JSON data' do
        # Assert the first record in items is obfuscated
        expect(subject[:items].first).not_to match(data[:items].first)
      end
    end
  end
end
