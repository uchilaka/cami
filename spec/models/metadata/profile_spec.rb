# frozen_string_literal: true

require 'rails_helper'

module Metadata
  RSpec.describe Profile, type: :model do
    include ActiveSupport::Testing::TimeHelpers

    let!(:user) { Fabricate(:user) }

    subject { user.profile }

    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_timestamps }

    describe 'validations' do
      it { is_expected.to validate_presence_of(:user_id) }
      it { is_expected.to validate_uniqueness_of(:user_id).case_insensitive }
    end

    describe 'fields' do
      around do |example|
        freeze_time { example.run }
      end

      it { is_expected.to have_field(:user_id).of_type(String) }
      it { is_expected.to have_field(:google).of_type(Hash) }
      it { is_expected.to have_field(:facebook).of_type(Hash) }
      it { is_expected.to have_field(:apple).of_type(Hash) }
      it { is_expected.to have_field(:image_url).of_type(String) }
      it { is_expected.to have_field(:last_seen_at).of_type(Time) }

      describe '#last_seen_at' do
        it 'defaults to the current time' do
          expect(subject.last_seen_at).to eq(Time.now)
        end
      end
    end
  end
end
