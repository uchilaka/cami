# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"
require 'active_support/core_ext/integer/time'
require_relative '../lib/virtual_office_manager'
require_relative '../lib/app_utils'
require_relative '../lib/log_utils'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cami
  class Application < Rails::Application
    # config.application_name = Rails.application.class.module_parent_name
    config.application_name = 'Customer Account Management & Invoicing'
    config.application_short_name = 'CAMI'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    config.exceptions_app = lambda do |env|
      ErrorsController.action(:show).call(env)
    end

    config.active_storage.variant_processor = :vips

    config.time_zone = 'Eastern Time (US & Canada)'

    # Setting the Active Job backend: https://guides.rubyonrails.org/active_job_basics.html#setting-the-backend
    config.active_job.queue_adapter = :sidekiq
    # # Active Job queues: https://guides.rubyonrails.org/active_job_basics.html#queues
    # config.active_job.queue_name_prefix = Rails.env

    config.active_record.query_log_tags =
      %i[
        application
        controller
        namespaced_controller
        action
        db_host
        database
        job
      ]

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << "#{root}/lib"

    # Autoload paths
    config.autoload_paths << "#{root}/lib/workflows"
    config.autoload_paths << "#{root}/lib/commands"
    config.autoload_paths << "#{root}/config/vcr"

    config.assets.paths << "#{root}/vendor/assets"

    # Configure allowed hosts. See doc https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
    config.hosts += config_for(:allowed_hosts)

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Doc for jbuilder: https://github.com/rails/jbuilder
    Jbuilder.key_format camelize: :lower
    Jbuilder.deep_format_keys true
  end
end
