# frozen_string_literal: true

require 'commands/lar_city/cli/base_cmd'

class ServicesCmd < LarCity::CLI::BaseCmd
  namespace 'services'

  options :profile,
          desc: 'The docker compose profile to use',
          type: :string,
          aliases: %w[-p --profile],
          default: 'essential'
  desc 'start', 'Start the services'
  def start
    run <<~CMD
      docker compose #{profile_clause} up -d &&\
      docker compose #{profile_clause} logs --follow
    CMD
  end

  desc 'stop', 'Stop the services'
  def stop
    raise NotImplementedError
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

    def profile_clause
      profile.presence ? "--profile #{profile}" : ""
    end

    def profile
      options[:profile]
    end
  end
end
