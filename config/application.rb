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
# Guide for ActionMailbox (processing inbound email): https://guides.rubyonrails.org/action_mailbox_basics.html
# require 'action_mailbox/engine'
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

module AccountManager
  class Application < Rails::Application
    config.application_name = Rails.application.class.module_parent_name
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_storage.variant_processor = :vips

    config.time_zone = 'Eastern Time (US & Canada)'

    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << "#{root}/lib"

    config.autoload_paths << "#{root}/lib/commands"
    config.autoload_paths << "#{root}/config/vcr"

    config.assets.paths << "#{root}/vendor/assets"

    # Configure allowed hosts. See doc https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
    config.hosts += config_for(:allowed_hosts)

    # Return nil when a document record is not found
    Mongoid.raise_not_found_error = false

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Setup default business entity
    config.default_entity = VirtualOfficeManager.default_entity
  end
end
