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
        Rails.env.production? || mailhog_enabled? || letter_opener_enabled?

      yes?(ENV.fetch('SEND_EMAILS_ENABLED', default_value))
    end

    def yes?(value)
      return true if [true, 1].include?(value)
      return false if value.nil?

      /^Y(es)?|^T(rue)|^On$/i.match?(value.to_s.strip)
    end

    def ping?(host)
      result = system("ping -c 1 -t 3 -W 1 #{host}", out: '/dev/null', err: '/dev/null')
      result.nil? ? false : result
    end

    def healthy?(resource_url)
      response = Faraday.get(resource_url) do |options|
        options.headers = {
          'User-Agent' => 'VirtualOfficeManager health check bot v1.0'
        }
      end
      Rails.logger.info "Health check for #{resource_url}", response: response.inspect
      response.success?
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error "Health check for #{resource_url} failed", error: e.message
      false
    end
  end
end
