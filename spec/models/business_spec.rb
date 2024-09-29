# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  slug         :string
#  status       :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
# Indexes
#
#  index_accounts_on_slug    (slug) UNIQUE
#  index_accounts_on_tax_id  (tax_id) UNIQUE WHERE (tax_id IS NOT NULL)
#
require 'rails_helper'

RSpec.describe Business, type: :model do
  subject { Fabricate :business }

  it { should have_and_belong_to_many(:users) }
  it { should have_many(:products).with_foreign_key(:vendor_id) }

  it 'delegates email to metadata' do
    expect(subject).to delegate_method(:email).to(:metadata)
  end

  pending "can be a resource in the context of a user's role"

  pending 'can have a role assigned'

  context 'when setting email' do
    let(:email) { Faker::Internet.email }

    it 'updates the profile' do
      expect { subject.update(email:) }.to change { subject.profile.email }.to(email)
    end
  end

  context 'when initializing' do
    let(:email) { Faker::Internet.email }

    subject { Fabricate(:business, email:) }

    it 'captures the business email in metadata' do
      expect(subject.metadata.email).to eq(email)
    end
  end

  context 'when email is invalid' do
    let(:email) { 'not-a-valid-email' }

    subject { Fabricate.build(:business, email:) }

    it 'validation fails' do
      expect(subject).to be_invalid
    end

    it 'reports an error' do
      expect { subject.valid? }.to \
        change { subject.errors[:email] }.to include('is not a valid email address')
    end
  end

  describe '#profile' do
    it 'aliases metadata' do
      expect(subject.metadata).to eq(subject.profile)
      expect(subject.profile).to be_a(Metadata::Business)
    end

    it 'returns the expected user profile' do
      expect(subject.profile).to eq(Metadata::Business.find_by(account_id: subject.id))
    end

    it 'returns a Metadata::Business' do
      expect(subject.profile).to be_a(Metadata::Business)
    end

    it 'is persisted' do
      expect(subject.profile).to be_persisted
    end
  end
end
