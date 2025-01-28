# frozen_string_literal: true

require 'fileutils'

class AppUtils
  class << self
    def configure_real_smtp?
      send_emails? && !letter_opener_enabled? && !mailhog_enabled?
    end

    # LetterOpener should be enabled by default in the development environment
    def letter_opener_enabled?
      configured_value = Rails.application.credentials.letter_opener_enabled
      return configured_value unless configured_value.nil?

      yes?(ENV.fetch('LETTER_OPENER_ENABLED', 'yes'))
    end

    def mailhog_enabled?
      configured_value = Rails.application.credentials.mailhog_enabled
      return configured_value unless configured_value.nil?

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

    def debug_assets?
      default_value = Rails.env.development? ? 'yes' : 'no'

      yes?(ENV.fetch('ENV_DEBUG_ASSETS', default_value))
    end

    def ruby_version(file_path = nil)
      file_path ||= "#{Dir.pwd}/.tool-versions"
      raise 'Error: .tool-versions file not found' unless File.exist?(file_path)

      File.foreach(file_path) do |line|
        match = line.match(/ruby\s+([\d.]+)/)
        return (match[1]).to_s.strip if match
      end

      raise 'No ruby version found in .tool-versions'
    end
  end
end
