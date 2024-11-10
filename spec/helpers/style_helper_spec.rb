# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StyleHelper, type: :helper do
  let!(:mock_class) do
    Class.new do
      include StyleHelper
      include Rails.application.routes.url_helpers
    end
  end

  subject { mock_class.new }

  describe 'for building a button class set' do
    let(:style) { :secondary }
    let(:disabled) { false }
    let(:append_class_names) { 'px-5 py-3' }
    let(:btn_secondary_set) do
      [
        'hover:text-white border focus:ring-4 focus:outline-none',
        'font-medium rounded-lg text-sm text-center me-2 mb-2',
        'dark:hover:text-white',
      ]
    end
    let(:btn_primary_set) do
      [
        'btn text-base font-medium text-white bg-gradient-to-br from-green-400 to-blue-600',
        'hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 dark:focus:ring-green-800',
        'font-medium rounded-lg text-sm text-center me-2 mb-2',
      ]
    end
    let(:test_set) do
      [
        append_class_names,
        {
          btn_primary_set => style == :primary,
          btn_secondary_set => style == :secondary || style.blank?
        },
        { 'cursor-not-allowed': disabled }
      ]
    end

    it { expect(subject.compose_class_names(*test_set)).to be_a(String) }

    context 'for a primary button' do
      let(:style) { :primary }

      it { expect(subject.compose_class_names(*test_set)).not_to include 'cursor-not-allowed' }
      it do
        expect(subject.compose_class_names(*test_set)).to \
          include 'btn text-base font-medium text-white bg-gradient-to-br from-green-400 to-blue-600 ' \
                  'hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 ' \
                  'dark:focus:ring-green-800'
      end
    end

    context 'for a secondary button' do
      let(:style) { :secondary }

      it { expect(subject.compose_class_names(*test_set)).not_to include 'cursor-not-allowed' }
      it do
        expect(subject.compose_class_names(*test_set)).to \
          include 'font-medium rounded-lg text-sm text-center me-2 mb-2 dark:hover:text-white'
      end
    end

    context 'for a default button that is disabled' do
      let(:style) { nil }
      let(:disabled) { true }

      it { expect(subject.compose_class_names(*test_set)).to start_with append_class_names }
      it { expect(subject.compose_class_names(*test_set)).to end_with 'cursor-not-allowed' }
      it do
        expect(subject.compose_class_names(*test_set)).to \
          include 'hover:text-white border focus:ring-4 focus:outline-none font-medium rounded-lg text-sm ' \
                  'text-center me-2 mb-2 dark:hover:text-white'
      end
    end
  end
end
