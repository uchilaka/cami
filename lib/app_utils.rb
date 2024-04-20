# frozen_string_literal: true

class AppUtils
  def self.yes?(value)
    return true if [true, 1].include?(value)
    return false if value.nil?

    /^Y(es)?|^T(rue)|^On$/i.match?(value.to_s.strip)
  end

  def self.initialize_log_streaming
    source_token = ENV.fetch('BETTERSTACK_SOURCE_TOKEN', Rails.application.credentials.betterstack.source_token)
    # BetterStack via HTTPS Appender
    appender = SemanticLogger::Appender::Http.new(
      url: 'https://in.logs.betterstack.com',
      ssl: { verify: OpenSSL::SSL::VERIFY_NONE },
      header: {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{source_token}"
      }
    )
    Rails.application.config.semantic_logger.add_appender(appender:)
  end
end
