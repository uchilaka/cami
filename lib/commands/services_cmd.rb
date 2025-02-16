# frozen_string_literal: true

require 'commands/lar_city/cli/base_cmd'

class ServicesCmd < LarCity::CLI::BaseCmd
  namespace 'services'

  class_option :profile,
          desc: 'The docker compose profile to use',
          type: :string,
          aliases: %w[-p --profile],
          default: 'essential'

  option :since,
          desc: 'Show logs since timestamp',
          type: :string,
          default: '15m' # 15 minutes

  # Docs: https://docs.docker.com/reference/cli/docker/compose/logs/
  desc 'logs', "Start streaming the app's containerized services logs"
  def logs
    run "docker compose #{profile_clause} logs --follow",
        since_clause
  end

  desc 'start', "Start the app's containerized services"
  def start
    run <<~CMD
      docker compose #{profile_clause} up -d &&\
        docker compose #{profile_clause} logs --follow
    CMD
  end

  desc 'stop', "Stop the app's containerized services"
  def stop
    run "docker compose #{profile_clause} stop"
  end

  desc 'teardown', 'Teardown the service artifacts (e.g., containers, volumes, networks)'
  def teardown
    run <<~CMD
      docker compose #{profile_clause} down --volumes &&\
        #{teardown_commands.join(' && ')}
    CMD
  end

  no_commands do
    def teardown_commands
      postgres_volumes_path.map do |path|
        "sudo rm -rf #{path}"
      end
    end

    def postgres_volumes_path
      %w[redis postgres/downloads postgres/docker-entrypoint-initdb.d].map do |dir|
        Rails.root.join('db', Rails.env, dir)
      end
    end

    def since_clause
      options[:since].presence ? "--since=#{options[:since]}" : ""
    end

    def profile_clause
      profile.presence ? "--profile=#{profile}" : ""
    end

    def profile
      options[:profile]
    end
  end
end
