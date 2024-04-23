# frozen_string_literal: true

# RSpec docs: https://rspec.info/features/3-12/rspec-core/

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
# Add additional requires below this line. Rails is not loaded until this point!
require 'rspec/rails'
require 'aasm/rspec'
require 'database_cleaner/active_record'
require 'sidekiq/testing'
require 'devise/test/integration_helpers'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# VCR usage docs https://benoittgt.github.io/vcr
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.allow_http_connections_when_no_cassette = true

  # IMPORTANT: Enables automatic cassette naming based on tags
  c.configure_rspec_metadata!

  # Setup :before_record hook to intercept PII data and prevent it from leaking into the cassettes
  c.before_record(:obfuscate) do |interaction, cassette|
    if interaction.response.body.present?
      if cassette.name.present? &&
        interaction.response.headers['content-type'].any? { |t| %r{application/json}.match?(t) }
        # Some housekeeping to prepare for making a dub of the original response
        dub_file = Rails.root.join('spec', 'fixtures', 'pii', "#{cassette.name}.json").to_s
        pii_path = File.dirname(dub_file)
        FileUtils.mkdir_p(pii_path) unless File.directory?(pii_path)
        # Prettify the JSON data for easier reading by humans
        og_response_data = JSON.pretty_generate(JSON.parse(interaction.response.body))
        # Save the original response body to a fixture location that can be
        #  validated but not committed to source control
        File.write(dub_file, og_response_data)
      end
      interaction.response.body = PIISanitizer.sanitize(interaction.response.body)
    end
  end
end

RSpec.configure do |config|
  config.fail_fast = ENV.fetch('CI', false) ? true : false

  config.include Mongoid::Matchers, type: :model

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('spec/fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Devise integration helpers https://github.com/heartcombo/devise?tab=readme-ov-file#integration-tests
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :view

  # Internationalization guide: https://guides.rubyonrails.org/i18n.html
  config.include AbstractController::Translation, type: :view
  config.include AbstractController::Translation, type: :helper

  config.before(:suite) do
    # Database cleaner setup: https://github.com/DatabaseCleaner/database_cleaner?tab=readme-ov-file#rspec-example
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Purge the MongoDB test store
    system "RAILS_ENV=test #{Rails.root}/bin/rails db:mongoid:drop"
    system "RAILS_ENV=test #{Rails.root}/bin/rails db:mongoid:create_collections"

    # Load seeds
    Rails.application.load_seed

    # Sidekiq setup
    Sidekiq::Testing.fake!
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
