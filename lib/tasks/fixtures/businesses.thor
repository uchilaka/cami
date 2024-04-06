# frozen_string_literal: true

require_relative '../../commands/lar_city_cli/base'

module Fixtures
  class Businesses < LarCityCLI::Base
    desc 'load', 'Load business fixtures'
    def load
      say 'Loading business fixtures...', Color::YELLOW
      fixtures_to_load =
        if Business.none?
          tally = fixtures.count
          say "Found #{tally} #{things(tally)} in the fixtures file.",
              Color::CYAN
          fixtures
        else
          fixtures_to_load = fixtures.reject { |b| Business.exists?(tax_id: b['tax_id']) }
          tally = fixtures_to_load.count
          say "Found #{tally} new #{things(tally)} in the fixtures file.",
              Color::CYAN
          fixtures_to_load
        end

      return if fixtures_to_load.empty?

      ap fixtures_to_load if verbose?

      return if dry_run?

      # Create the new records
      result = Business.create(fixtures_to_load)
      if result.all?(&:valid?)
        say 'All records were created successfully.', Color::GREEN
      else
        say 'Some records could not be created.', Color::RED
        ap result.reject(&:valid?) if verbose?
      end

      return unless verbose?

      tally = Business.count
      say "There are now #{tally} #{things(tally)} in the database.", Color::MAGENTA
    end

    private

    def things(count)
      'business'.pluralize(count)
    end

    def fixtures
      @fixtures ||= YAML.load(
        ERB.new(
          File.read(Rails.root.join('spec/fixtures/businesses.yml').to_s)
        ).result
      )
    end
  end
end
