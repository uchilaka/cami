# frozen_string_literal: true

require_relative 'base_cmd'

<<<<<<<< HEAD:lib/commands/lar_city/cli/devkit_cmd.thor
module LarCityCLI
  class DevkitCmd < BaseCmd
    namespace :'lx-cli:devkit'
========
module LarCity::CLI
  class DevkitCmd < BaseCmd
    namespace 'devkit'
>>>>>>>> refactor/templates_and_styling:lib/commands/lar_city/cli/devkit_cmd.rb

    desc 'swaggerize', 'Generate Swagger JSON file(s)'
    def swaggerize
      cmd = 'bundle exec rails rswag'
      if verbose?
        puts <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
      end

      return if dry_run?

      ClimateControl.modify RAILS_ENV: 'test' do
        system(cmd)
      end
    end

    desc 'logs', 'Show the logs for the project'
    def logs
      raise Errors::UnsupportedOSError, 'Unsupported OS' unless mac?

      cmd = "open --url #{log_stream_url}"
      if verbose?
        puts <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
      end
      system(cmd) unless dry_run?
    end

    private

    def log_stream_url
      team_id, source_id = Rails.application.credentials.betterstack.values_at :team_id, :source_id
      "https://logs.betterstack.com/team/#{team_id}/tail?s=#{source_id}"
    end
  end
end
