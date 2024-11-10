# frozen_string_literal: true

Rails.configuration.before_initialize do |app|
  LogUtils.initialize_stream unless Rails.env.test? || LogUtils.streaming_via_http?
  # Configure logging for dependent services
  app.config.action_mailer.logger = Rails.logger
end
