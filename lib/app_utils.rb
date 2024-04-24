# frozen_string_literal: true

require 'fileutils'

class AppUtils
  class << self
    def configure_real_smtp?
      send_emails? && !letter_opener_enabled? && !mailhog_enabled?
    end

    # LetterOpener should be enabled by default in the development environment
    def letter_opener_enabled?
      yes?(ENV.fetch('LETTER_OPENER_ENABLED', 'yes'))
    end

    def mailhog_enabled?
      yes?(ENV.fetch('MAILHOG_ENABLED', 'no'))
    end

    def send_emails?
      default_value =
        if Rails.env.production?
          'yes'
        elsif mailhog_enabled? || letter_opener_enabled?
          'yes'
        else
          'no'
        end

      yes?(ENV.fetch('SEND_EMAIL_ENABLED', default_value))
    end

    def yes?(value)
      return true if [true, 1].include?(value)
      return false if value.nil?

      /^Y(es)?|^T(rue)|^On$/i.match?(value.to_s.strip)
    end
  end
end
