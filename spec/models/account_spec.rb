# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  metadata     :jsonb
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { Fabricate :account }

  it { should validate_presence_of :display_name }
  it { should validate_presence_of :slug }
  it { should validate_uniqueness_of(:slug).case_insensitive }
  it { should have_and_belong_to_many(:members) }
  it { should have_many(:invoices) }

  describe '#tax_id' do
    context 'when blank' do
      subject { Fabricate :account, tax_id: '' }

      it { expect(subject).to be_valid }
    end

    context 'when present in the database (case insensitive)' do
      let!(:account) { Fabricate :account, tax_id: 'ax-123456789' }

      subject { Fabricate.build :account, tax_id: 'AX-123456789' }

      it { expect(subject).to be_invalid }

      it 'fails validation on save' do
        expect { subject.save! }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe '#status' do
    it { transition_from(%i[demo draft guest]).to(:active).on_event(:activate) }
    it { transition_from(%i[active payment_due overdue]).to(:paid).on_event(:enroll) }
    it { transition_from(%i[active payment_due overdue]).to(:suspended).on_event(:suspend) }
    it { transition_from(%i[suspended overdue deactivated]).to(:active).on_event(:reactivate) }
    it { transition_from(%i[payment_due overdue suspended]).to(:deactivated).on_event(:deactivate) }

    it 'is draft by default' do
      expect(subject.status).to eq 'draft'
    end

    context 'is invalid' do
      subject { Fabricate.build :account, status: 'not_valid' }

      it { expect { subject }.to raise_error(ArgumentError, "'not_valid' is not a valid status") }
    end

    context 'is nil' do
      let(:account) { Fabricate.build :account, status: nil }

      it { expect(account.status).to eq 'draft' }
    end

    context 'is valid' do
      let(:account) { Fabricate.build :account, status: 'demo' }

      it { expect(account).to be_valid }

      it { expect(account.status).to eq('demo') }
    end
  end

  describe '#invoices', skip: 'pending' do
    let(:account) { Fabricate :account }
    let(:invoice) { Fabricate :invoice }

    pending 'can be accessed via "customer" role'
  end
end
