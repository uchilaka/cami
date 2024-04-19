# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NavbarHelper, type: :helper do
  let!(:mock_class) do
    Class.new do
      include NavbarHelper
      include AbstractController::Translation
      include Rails.application.routes.url_helpers

      attr_reader :current_user
    end
  end

  let(:user) { Fabricate :user }

  before do
    allow_any_instance_of(mock_class).to receive(:current_user) { user }
  end

  subject { mock_class.new }

  describe '#main_menu' do
    it 'returns an array of menu items' do
      expect(subject.main_menu).to be_an_instance_of(Array)
    end

    it 'returns an array of structs' do
      subject.main_menu.each { |item| expect(item).to be_an_instance_of(Struct::NavbarItem) }
    end

    it 'returns the expected menu items enabled by default' do
      expect(subject.main_menu.pluck(:label)).to match_array %w[Home Dashboard Accounts]
    end
  end
end
