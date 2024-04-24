# frozen_string_literal: true

require 'fileutils'

class AppUtils
  class << self
    def yes?(value)
      return true if [true, 1].include?(value)
      return false if value.nil?

      /^Y(es)?|^T(rue)|^On$/i.match?(value.to_s.strip)
    end

    # LetterOpener should be enabled by default in the development environment
    def letter_opener_enabled?
      !yes?(ENV.fetch('LETTER_OPENER_DISABLED', 'no'))
    end

    def send_emails?
      yes?(ENV.fetch('SEND_EMAIL_ENABLED', Rails.env.production? ? 'yes' : 'no'))
    end
  end
end
