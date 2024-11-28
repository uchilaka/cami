# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Enable web console for all IP addresses (see https://stackoverflow.com/a/71292229)
  # To enable all IP v6 addresses, use '::/0'
  config.web_console.permissions = '0.0.0.0/0'
  # When a console cannot be shown for a given IP address or content type, messages
  # such as the following is printed in the server logs:
  # > Cannot render console from 192.168.1.133! Allowed networks: 127.0.0.0/127.255.255.255, ::1
  #
  # If you don't want to see this message anymore, set this option to false:
  config.web_console.whiny_requests = true

  # Note on issues with calling the web console:
  # https://github.com/rails/web-console?tab=readme-ov-file#why-does-the-console-only-appear-on-error-pages-but-not-when-i-call-it
  config.middleware.insert(0, Rack::Deflater)

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  Dotenv.load(*%w[.env.local .env].select do |file|
    File.exist?(file)
  end)

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = AppUtils.yes?(ENV.fetch('ENV_CONSIDER_ALL_REQUESTS_LOCAL', 'yes'))

  # Enable server timing
  config.server_timing = true

  config.rails_semantic_logger.started    = true
  config.rails_semantic_logger.processing = AppUtils.yes?(ENV.fetch('SEMANTIC_LOGGER_PROCESSING_ENABLED', 'no'))
  config.rails_semantic_logger.rendered   = AppUtils.yes?(ENV.fetch('SEMANTIC_LOGGER_RENDERED_ENABLED', 'no'))
  config.semantic_logger.backtrace_level = :info
  config.log_level = :debug

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_deliveries = AppUtils.mailhog_enabled? || AppUtils.letter_opener_enabled?
  config.action_mailer.delivery_method =
    if AppUtils.letter_opener_enabled?
      :letter_opener
    else
      :smtp
    end

  # IMPORTANT: If you will be using the mailhog service for testing emails locally,
  #   be sure to set LETTER_OPENER_ENABLED=no (it is set to 'yes' by default).
  #   The LetterOpener gem will save emails as files to ./tmp/email/inbox.
  #
  # Configure the mailer to use the SMTP server
  config.action_mailer.smtp_settings =
    if AppUtils.configure_real_smtp?
      {
        address: ENV.fetch('SMTP_SERVER', Rails.application.credentials.brevo.smtp_server),
        port: ENV.fetch('SMTP_PORT', Rails.application.credentials.brevo.smtp_port),
        user_name: ENV.fetch('SMTP_USERNAME', Rails.application.credentials.brevo.smtp_user),
        password: ENV.fetch('SMTP_PASSWORD', Rails.application.credentials.brevo.smtp_password),
        enable_starttls_auto: true
      }
    else
      { address: 'localhost', port: 1025 }
    end

  # Configure logging for the app's mail service.
  config.action_mailer.logger = Rails.logger
  # IMPORTANT: This will affect whether letter_opener can open the email in the browser or not
  # TODO: Spec this config across development, staging and production
  config.action_mailer.default_url_options = VirtualOfficeManager.default_url_options

  # TODO: This doesn't seem to be doing what it's supposed to do
  config.after_initialize do
    if !VirtualOfficeManager.job_queue_is_running? && defined?(Rails::Server)
      # Schedule an NGROK tunnel check to update the mailer default URL options
      UpdateMailerDefaultURLOptionsJob.set(wait: 15.seconds).perform_later
    end
  end

  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false

  # config.action_mailer.default_url_options = { host: 'localhost', port: ENV.fetch('PORT', 16_006) }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  # For more on configuring active record query logs:
  # https://api.rubyonrails.org/classes/ActiveRecord/QueryLogs.html
  config.active_record.verbose_query_logs =
    AppUtils.yes?(ENV.fetch('ENV_VERBOSE_QUERY_LOGS', 'no'))

  # Setting the Active Job backend: https://guides.rubyonrails.org/active_job_basics.html#setting-the-backend
  config.active_job.queue_adapter = :sidekiq

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs =
    AppUtils.yes?(ENV.fetch('ENV_VERBOSE_ENQUEUE_LOGS', 'no'))

  # Suppress logger output for asset requests.
  config.assets.quiet = !AppUtils.debug_assets?

  # Turn on source maps
  config.assets.debug = AppUtils.debug_assets?

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions =
    AppUtils.yes?(ENV.fetch('ENV_RAISE_ON_MISSING_CALLBACK_ACTIONS', 'no'))

  # Apply autocorrection by RuboCop to files generated by `bin/rails generate`.
  # config.generators.apply_rubocop_autocorrect_after_generate!
end
