# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceAccountSerializer do
  describe '#attributes' do
    let(:serializer) { described_class.new(invoice_account) }
    let(:invoice_account) do
      {
        'billing_info' => {}
      }
    end

    context 'when the invoice account is a business' do
      let(:invoice_account) do
        {
          'billing_info' => {
            'business_name' => Faker::Company.name,
            'email_address' => Faker::Internet.email
          }
        }
      end

      it 'returns the business attributes' do
        expect(serializer.attributes).to eq(
          display_name: invoice_account['billing_info']['business_name'],
          email: invoice_account['billing_info']['email_address'],
          type: 'Business'
        )
      end
    end

    context 'when the invoice account is an individual' do
      let(:given_name) { Faker::Name.gender_neutral_first_name }
      let(:family_name) { Faker::Name.last_name }
      let(:invoice_account) do
        {
          'billing_info' => {
            'name' => {
              'given_name' => given_name,
              'family_name' => family_name,
              'full_name' => "#{given_name} #{family_name}"
            }
          }
        }
      end

      it 'returns the individual attributes' do
        expect(serializer.attributes).to eq(
          given_name: invoice_account['billing_info']['name']['given_name'],
          family_name: invoice_account['billing_info']['name']['family_name'],
          display_name: invoice_account['billing_info']['name']['full_name'],
          email: invoice_account['billing_info']['email_address'],
          type: 'Individual'
        )
      end
    end
  end
end
