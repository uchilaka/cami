# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/features', type: :request do
  let(:flag) { 'feat__products' }
  let(:data) { JSON.parse(response.body) }

  subject { data['features'] }

  context 'with a feature' do
    context 'and a logged in user' do
      let(:user) { Fabricate :user }

      before { sign_in user }

      context "that's enabled for the user" do
        before do
          Flipper.enable flag, user
          get api_features_url
        end

        after { Flipper.disable flag, user }

        it { expect(subject[flag]).to be true }
      end

      context "that's enabled for a different user" do
        let(:different_user) { Fabricate :user }

        before do
          Flipper.enable flag, different_user
          get api_features_url
        end

        it { expect(subject[flag]).to be false }
      end

      context "that's enabled for everyone" do
        before do
          Flipper.enable flag
          get api_features_url
        end

        after { Flipper.disable flag }

        it { expect(subject[flag]).to be true }
      end

      context "that's disabled" do
        before { get api_features_url }

        xit { expect(subject[flag]).to be false }
      end
    end

    context "that's enabled for all users" do
      before do
        Flipper.enable flag
        get api_features_url
      end

      after { Flipper.disable flag }

      it { expect(subject[flag]).to be true }
    end

    pending "that's disabled"
  end
end
