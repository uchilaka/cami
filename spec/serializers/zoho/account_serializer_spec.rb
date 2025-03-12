# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Zoho::AccountSerializer do
  let(:display_name) { Faker::Company.name }
  let(:email) { Faker::Internet.email }
  let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }
  let(:website) { Faker::Internet.url(host: 'fake.site') }
  let(:account) { Fabricate(:account, display_name:, email:, phone_number:) }

  subject { described_class.new(account).serializable_hash }

  shared_examples 'an account serializable to the CRM' do |expected_type, expected_keys|
    it { expect(account.phone['number_type']).to eq(expected_type) }
    expected_keys.each do |serialized_key|
      it { expect(subject.keys).to include(serialized_key) }
    end
  end

  describe '#phone_number' do
    context 'with some example phone numbers' do
      [
        ['+49 16 30580 9607', 'mobile'], # Germany
        ['+234 712 924 8348', 'mobile'], # Nigeria
        ['+1 202-555-0113', 'fixed_or_mobile'], # United States
        ['+44 20 7946 0958', 'fixed_line'] # United Kingdom
      ].each do |phone_number, expected_type|
        context "with phone number #{phone_number}" do
          let(:phone_number) { phone_number }

          if expected_type == 'mobile'
            it_should_behave_like 'an account serializable to the CRM', expected_type, %i[Email Account_Name Phone Mobile]
          else
            it_should_behave_like 'an account serializable to the CRM', expected_type, %i[Email Account_Name Phone]
          end
        end
      end
    end

    context 'with cell phone number' do
      let(:phone_number) { Faker::PhoneNumber.cell_phone_in_e164 }

      before do
        allow_any_instance_of(Phonelib::Phone).to receive(:types).and_return(%i[mobile])
      end

      it_should_behave_like 'an account serializable to the CRM', 'mobile', %i[Email Account_Name Mobile]
    end

    context 'with fixed line phone number' do
      let(:phone_number) { Faker::PhoneNumber.phone_number_with_country_code }

      before do
        allow_any_instance_of(Phonelib::Phone).to receive(:types).and_return(%i[fixed])
      end

      it_should_behave_like 'an account serializable to the CRM', 'fixed', %i[Email Account_Name Phone]
    end

    context 'with ambiguous phone number' do
      let(:phone_number) { Faker::PhoneNumber.phone_number }

      before do
        allow_any_instance_of(Phonelib::Phone).to receive(:types).and_return(%i[fixed_or_mobile other])
      end

      it_should_behave_like 'an account serializable to the CRM', 'fixed_or_mobile', %i[Email Account_Name Phone]
    end

    pending 'without phone number'
  end

  describe '#email' do
    pending 'without email address'
  end

  describe '#description' do
    pending 'without description'

    context 'with description' do
      let(:readme) do
        <<~TRIX_HTML
          <h2>Notes from the first meeting</h2>
          <ul>
            <li>This is that "spicy lettuce" company <em>every</em> millenial was nuts about in high school.</li>
            <li><strong>DO NOT BRING UP SPICY LETTUCE!</strong>This client hates that.</li>
          </ul>

          <h2>Next steps</h2>
          <p><strong>CALL BOB!</strong> He's the decision maker.</p>
        TRIX_HTML
      end
      let(:expected_description) do
        <<~MARKDOWN
          ## Notes from the first meeting

          - This is that "spicy lettuce" company _every_ millenial was nuts about in high school.
          - **DO NOT BRING UP SPICY LETTUCE!** This client hates that.

          ## Next steps

          **CALL BOB!** He's the decision maker.

        MARKDOWN
      end
      let(:account) { Fabricate(:account, display_name:, email:, phone_number:, readme:) }

      it { expect(subject[:Description]).to eq(expected_description) }
    end
  end
end
