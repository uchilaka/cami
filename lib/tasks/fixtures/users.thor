# frozen_string_literal: true

module Fixtures
  class Users < LarCityCLI::BaseCmd
    desc 'load', 'Load application users'
    def load
      say 'Loading users...', Color::YELLOW
      fixtures_to_load =
        if User.none?
          tally = fixtures.count
          say "Found #{tally} #{things(tally)} in the fixtures file.",
              Color::CYAN
          fixtures
        else
          fixtures_to_load = fixtures.reject { |b| record_exists?(b) }
          tally = fixtures_to_load.count
          say "Found #{tally} new #{things(tally)} in the fixtures file.",
              Color::CYAN
          fixtures_to_load
        end

      return if fixtures_to_load.empty?

      ap fixtures_to_load if verbose?
      return if dry_run?

      if fixtures_to_load.none?
        say 'No new users to load', Color::GREEN
        return
      end

      # Process user records
      results = User.create!(fixtures_to_load)
      if results&.all?(&:valid?)
        Rails.logger.info "Saved #{results.count} records"
      else
        saved_records = results.reject { |record| record.errors.any? }
        Rails.logger.warn "Saved #{saved_records.count} of #{fixtures_to_load.count} records"
      end
    end

    protected

    def things(count)
      'user'.pluralize(count)
    end

    private

    def record_exists?(record)
      User.exists?(email: record['email'])
    end

    def fixtures
      @fixtures ||= YAML.load(
        ERB.new(
          File.read(Rails.root.join('spec/fixtures/users.yml'))
        ).result
      )
    end
  end
end
