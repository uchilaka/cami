# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppUtils do
  describe '.ping?' do
    it 'returns true if host is reachable' do
      expect(described_class.ping?('google.com')).to eq(true)
    end

    it 'returns false if host is not reachable' do
      expect(described_class.ping?('notarealhost')).to eq(false)
    end
  end

  describe '.yes?' do
    it 'returns true if value is true' do
      expect(described_class.yes?(true)).to eq(true)
    end

    it 'returns true if value is 1' do
      expect(described_class.yes?(1)).to eq(true)
    end

    it 'returns false if value is nil' do
      expect(described_class.yes?(nil)).to eq(false)
    end

    it 'returns true if value is "yes"' do
      expect(described_class.yes?('yes')).to eq(true)
    end

    it 'returns true if value is "true"' do
      expect(described_class.yes?('true')).to eq(true)
    end

    it 'returns true if value is "on"' do
      expect(described_class.yes?('on')).to eq(true)
    end

    it 'returns false if value is "no"' do
      expect(described_class.yes?('no')).to eq(false)
    end
  end

  describe '.letter_opener_enabled?' do
    let(:letter_opener_disabled) { nil }

    around do |example|
      with_modified_env(LETTER_OPENER_DISABLED: letter_opener_disabled) do
        example.run
      end
    end

    context 'when LETTER_OPENER_DISABLED is nil' do
      it 'returns true' do
        expect(described_class.letter_opener_enabled?).to eq(true)
      end
    end

    context 'when LETTER_OPENER_DISABLED is "yes"' do
      let(:letter_opener_disabled) { 'yes' }

      it 'returns false' do
        expect(described_class.letter_opener_enabled?).to eq(false)
      end
    end

    context 'when LETTER_OPENER_DISABLED is "no"' do
      let(:letter_opener_disabled) { 'no' }

      it 'returns true' do
        expect(described_class.letter_opener_enabled?).to eq(true)
      end
    end
  end

  describe '.send_emails?' do
    let(:send_email_enabled) { nil }

    around do |example|
      with_modified_env(SEND_EMAIL_ENABLED: send_email_enabled) do
        example.run
      end
    end

    context 'when SEND_EMAIL_ENABLED is nil' do
      it 'returns false' do
        expect(described_class.send_emails?).to eq(false)
      end
    end

    context 'when SEND_EMAIL_ENABLED is "no"' do
      let(:send_email_enabled) { 'no' }

      it 'returns false' do
        expect(described_class.send_emails?).to eq(false)
      end
    end

    context 'when SEND_EMAIL_ENABLED is "yes"' do
      let(:send_email_enabled) { 'yes' }

      it 'returns true' do
        expect(described_class.send_emails?).to eq(true)
      end
    end

    context 'when SEND_EMAIL_ENABLED is not set and Rails.env.production? is true' do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      after do
        allow(Rails.env).to receive(:production?).and_call_original
      end

      it 'returns true' do
        expect(described_class.send_emails?).to eq(true)
      end
    end
  end
end
