# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportUserProfileWorkflow do
  let!(:invoice) { Fabricate :invoice }

  let(:email) { Faker::Internet.email }
  let(:given_name) { nil }
  let(:family_name) { nil }
  let(:invoice_account) { invoice.accounts.find_by(email:) }
  let(:payment_vendor) { invoice.payment_vendor }
  let(:new_user_profile) { Metadata::Profile.find_by("vendor_data.#{payment_vendor}.email": email) }

  subject { described_class.call(invoice_account:) }

  shared_examples 'a new profile is created' do |first_name, last_name = nil|
    let(:given_name) { first_name }
    let(:family_name) { last_name }

    it 'succeeds' do
      expect(subject.success?).to be(true)
    end

    it 'creates the expected new profile' do
      expect { subject }.to change(Metadata::Profile, :count).by(1)
      expect(subject.profile).to eq(new_user_profile)
    end

    it 'sets the profile in context' do
      expect(subject.profile).not_to be_nil
      expect(subject.profile).to eq(new_user_profile)
    end
  end

  context 'with embedded business account data' do
    let!(:invoice) do
      Fabricate :invoice,
                accounts: [
                  {
                    display_name: Faker::Company.name,
                    given_name:, family_name:,
                    type: 'Business',
                    email:
                  }
                ]
    end

    context 'when the email address is missing' do
      let(:email) { nil }
      let(:invoice_account) { invoice.accounts.find_by(email:, type: 'Business') }

      it 'fails with the expected error message' do
        expect { subject }.not_to change(Metadata::Profile, :count)
        expect(subject.success?).to be(false)
        expect(subject.errors).to include(I18n.t('workflows.import_user_profile.errors.email_required'))
      end
    end

    context 'when the email address is present' do
      let(:email) { Faker::Internet.email }
      let(:invoice_account) { invoice.accounts.find_by(email:, type: 'Business') }

      context 'and there are no given or family names' do
        it 'fails with the expected error message' do
          expect { subject }.not_to change(Metadata::Profile, :count)
          expect(subject.success?).to be(false)
          expect(subject.errors).to include(I18n.t('workflows.import_user_profile.errors.name_required'))
        end
      end

      context 'and there is a first name' do
        let(:given_name) { 'Andy' }
        let(:family_name) { nil }

        it_should_behave_like 'a new profile is created', 'Andy', nil

        it 'sets the given name in the profile' do
          subject
          expect(new_user_profile.vendor_data[payment_vendor]['given_name']).to eq('Andy')
        end
      end

      context 'and there is a last name' do
        let(:given_name) { nil }
        let(:family_name) { 'Hahn' }

        it_should_behave_like 'a new profile is created', nil, 'Hahn'

        it 'sets the family name in the profile' do
          subject
          expect(new_user_profile.vendor_data[payment_vendor]['family_name']).to eq('Hahn')
        end
      end

      context 'and there are both first and last names' do
        it_should_behave_like 'a new profile is created', Faker::Name.neutral_first_name, Faker::Name.last_name
      end
    end
  end

  context 'with embedded individual account data' do
    let!(:invoice) do
      Fabricate :invoice,
                accounts: [
                  {
                    given_name:, family_name:,
                    type: 'Individual',
                    email:
                  }
                ]
    end

    context 'when the email address is missing' do
      let(:email) { nil }
      let(:given_name) { Faker::Name.neutral_first_name }
      let(:invoice_account) { invoice.accounts.find_by(email:, type: 'Individual') }

      subject { described_class.call(invoice_account:) }

      it 'fails with the expected error message' do
        expect { subject }.not_to change(Metadata::Profile, :count)
        expect(subject.success?).to be(false)
        expect(subject.errors).to include(I18n.t('workflows.import_user_profile.errors.email_required'))
      end
    end

    context 'when the email address is present' do
      let(:invoice_account) { invoice.accounts.find_by(email:, type: 'Individual') }

      context 'and there is a first name' do
        let(:given_name) { 'Sutton' }
        let(:family_name) { nil }

        it_should_behave_like 'a new profile is created', 'Sutton', nil

        it 'sets the given name in the profile' do
          subject
          expect(new_user_profile.vendor_data[payment_vendor]['given_name']).to eq('Sutton')
        end
      end

      context 'and there is a last name' do
        let(:given_name) { nil }
        let(:family_name) { 'Donnelly' }

        it_should_behave_like 'a new profile is created', nil, 'Donnelly'

        it 'sets the family name in the profile' do
          subject
          expect(new_user_profile.vendor_data[payment_vendor]['family_name']).to eq('Donnelly')
        end
      end

      context 'and there are both first and last names' do
        it_should_behave_like 'a new profile is created', Faker::Name.neutral_first_name, Faker::Name.last_name
      end
    end
  end
end
