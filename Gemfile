# frozen_string_literal: true

$LOAD_PATH.unshift Dir.pwd

require 'lib/app_utils'

source 'https://rubygems.org'

ruby AppUtils.ruby_version

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2', '>= 7.2.2.1'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# The speed of a single-page web application without having to write any JavaScript.
gem 'turbo-rails', '~> 2.0'

# Autoload dotenv in Rails https://github.com/bkeepers/dotenv
# IMPORTANT: This should be loaded as early as possible
gem 'dotenv', groups: %i[development test], require: 'dotenv/load'

# Redis feature flag adapter for Flipper
gem 'flipper-api', '~> 1.3'
gem 'flipper-redis', '~> 1.2'
gem 'flipper-ui', '~> 1.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

gem 'active_record_extended'

# ActiveRecord soft-deletes done right https://github.com/jhawthorn/discard?tab=readme-ov-file#discard-
gem 'discard', '~> 1.4'

# OO authorization for Rails [https://github.com/varvet/pundit]
gem 'pundit', '~> 2.3'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Tailwind CSS for stylesheets [https://tailwindcss.com/docs/guides/ruby-on-rails]
gem 'tailwindcss-rails', '~> 3.0'

# Integrate Dart Sass with the asset pipeline in Rails [https://github.com/rails/dartsass-rails]
gem 'dartsass-rails', '~> 0.5'

# Integrate SassC-Ruby into Rails.
gem 'sassc-rails', '~> 2.1'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# Refer to any model with a URI: gid://app/class/id
gem 'globalid', '~> 1.2'

gem 'awesome_print'

# Gem validates phone numbers with Google libphonenumber database [https://github.com/daddyz/phonelib]
gem 'phonelib'

# Roles library with resource scoping
gem 'rolify', '~> 6.0'

# Executes code after database commit wherever you want in your application (Required by AASM)
gem 'after_commit_everywhere', '~> 1.0'

# State machine mixin for Ruby objects
gem 'aasm', '~> 5.5'

# Feature rich logging framework that replaces the Rails logger.
gem 'rails_semantic_logger'

# Better Stack Rails integration
gem 'logtail-rails'

# Find slowly loading gems for your Bundler-based projects
gem 'bumbler'

# Rationale: setup "staging" environments to be identical to production, distinguished by their domain name.
gem 'sib-api-v3-sdk', groups: %i[production]

gem 'active_model_serializers'

# OpenAPI (formerly named Swagger) tooling for Rails APIs https://github.com/rswag/rswag
gem 'rswag-api'
gem 'rswag-ui'

# See https://youtrack.jetbrains.com/issue/RUBY-32741/Ruby-Debugger-uninitialized-constant-ClassDebaseValueStringBuilder...#focus=Comments-27-9677540.0-0
gem 'ostruct'

# Simple, feature rich ascii table generation library https://github.com/tj/terminal-table
gem 'terminal-table'

group :development, :test do
  gem 'capybara'
  gem 'capybara_accessibility_audit'
  gem 'climate_control'
  gem 'fabrication'
  gem 'faker'
  gem 'open3'
  gem 'rspec-wait'
  gem 'rubocop'

  # Catch unsafe migrations in development https://github.com/ankane/strong_migrations
  gem 'strong_migrations'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities https://brakemanscanner.org/
  gem 'brakeman', require: false

  # Omakase Ruby styling https://github.com/rails/rubocop-rails-omakase/
  gem 'rubocop-rails-omakase', require: false

  gem 'rspec-rails', '~> 7.0.0'

  gem 'rswag-specs'
end

group :development do
  # Use console on exceptions pages https://github.com/rails/web-console
  gem 'web-console'

  # Ruby on Rails Live Reload https://github.com/railsjazz/rails_live_reload
  gem 'rails_live_reload'

  # Annotates Rails Models, routes, fixtures, and others based on the database schema.
  gem 'annotate'

  # Preview mail in browser instead of sending.
  gem 'letter_opener'
end

group :test do
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Record your test suite's HTTP interactions and replay them during future test runs for fast,
  #   deterministic, accurate tests
  gem 'vcr', '~> 6.2'

  gem 'shoulda-matchers'

  # Selenium is a browser automation tool for automated
  #   testing of webapps and more https://www.selenium.dev/documentation/en/
  gem 'selenium-webdriver'

  gem 'database_cleaner-active_record'

  # gem 'database_cleaner-redis'
end

# Track changes to your models https://github.com/paper-trail-gem/paper_trail
gem 'paper_trail', '~> 15.2'

# Flexible authentication solution for Rails with Warden https://github.com/heartcombo/devise
gem 'devise'

# JWT authentication for devise
gem 'devise-jwt', '~> 0.11'

# Middleware for enabling Cross-Origin Resource Sharing in Rack apps
gem 'rack-cors', '~> 2.0'

# Passwordless (email-only) login strategy for Devise https://github.com/abevoelker/devise-passwordless
gem 'devise-passwordless'

# Provides CSRF protection on OmniAuth request endpoint on Rails application.
gem 'omniauth-rails_csrf_protection'

# OmniAuth strategy for Sign in with Apple https://github.com/nhosoya/omniauth-apple
# gem 'omniauth-apple'

# A Google OAuth2 strategy for OmniAuth 1.x https://github.com/zquestz/omniauth-google-oauth2
gem 'omniauth-google-oauth2'

# Presenting names of people in full, familiar, abbreviated, and initialized forms (but without titulation etc)
gem 'name_of_person'

# A fast image processing library with low memory needs
gem 'ruby-vips', '~> 2.1', '>= 2.1.4'

# Use Vite in Rails for JS https://github.com/ElMassimo/vite_ruby
gem 'vite_rails', '~> 3.0', '>= 3.0.17'

# Pin a minimum version of the stringio gem (spaghetti change while troubleshooting Sidekiq on WSL2)
gem 'stringio', '>= 3.1.2'

# Simple, efficient background processing for Ruby https://github.com/sidekiq/sidekiq/wiki/Getting-Started
gem 'sidekiq', '~> 7.3'

# Scheduler/Cron for Sidekiq jobs https://github.com/sidekiq-cron/sidekiq-cron?tab=readme-ov-file#adding-cron-job
gem 'sidekiq-cron'

# Process manager for applications with multiple components
gem 'foreman'

# Rake tasks to migrate data alongside schema changes https://github.com/ilyakatz/data-migrate
gem 'data_migrate', '~> 9', '>= 9.3.0'

# Simple interactor implementation
gem 'interactor', '~> 3.1'

# Money gem integration with Rails https://github.com/RubyMoney/money-rails
gem 'money-rails', '~> 1.15'

# Object-based searching for Active Record https://github.com/activerecord-hackery/ransack
gem 'ransack', '~> 4.2'

# # API client for Zoho CRM https://github.com/zoho/zohocrm-ruby-sdk-7.0
# TODO: Encounters error installing mysql2 (pivoting away from pulling in this dependency)
# gem 'ZOHOCRMSDK7_0'
