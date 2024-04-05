# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Autoload dotenv in Rails https://github.com/bkeepers/dotenv
# IMPORTANT: This should be loaded as early as possible
gem 'dotenv', groups: %i[development test], require: 'dotenv/load'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Elegant Persistence in Ruby for MongoDB.
gem 'mongoid', '~> 8.1.0'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Integrate Dart Sass with the asset pipeline in Rails https://github.com/rails/dartsass-rails
gem 'dartsass-rails'

# Use Tailwind CSS for stylesheets https://tailwindcss.com/docs/guides/ruby-on-rails
gem 'tailwindcss-rails', '~> 2.3'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem 'interactor', '~> 3'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'capybara'
  gem 'capybara_accessibility_audit'
  gem 'fabrication'
  gem 'faker'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.1'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'strong_migrations'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'annotate'
end

group :test do
  # Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests
  gem 'vcr', '~> 6.2'

  gem 'shoulda-matchers'
  # Selenium is a browser automation tool for automated testing of
  #     webapps and more [https://www.selenium.dev/documentation/en/]
  gem 'selenium-webdriver'

  gem 'database_cleaner-active_record'

  # TODO: The transaction strategy is not supported by Mongoid.
  #   You can use the deletion strategy to clean the document store.
  # gem 'database_cleaner-mongoid'
  # gem 'database_cleaner-redis'

  gem 'climate_control'
end

gem 'devise'
gem 'name_of_person'
gem 'ruby-vips', '~> 2.1', '>= 2.1.4'
gem 'vite_rails', '~> 3.0', '>= 3.0.17'
gem 'vite_ruby', '~> 3.2', '>= 3.2.2'

# Simple, efficient background processing for Ruby [https://github.com/sidekiq/sidekiq/wiki/Getting-Started]
gem 'sidekiq', '~> 7.2', '>= 7.2.0'

# Scheduler/Cron for Sidekiq jobs
gem 'sidekiq-cron'

# Process manager for applications with multiple components
gem 'foreman'

# Rake tasks to migrate data alongside schema changes [https://github.com/ilyakatz/data-migrate]
gem 'data_migrate', '~> 9.2', '>= 9.2.0'
