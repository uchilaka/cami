require 'thor'

module LarCityCLI
  # Manage data stores for the project
  class DataStores < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: true, # TODO: Change this to false before shipping
                 required: false
    class_option :dry_run,
                 type: :boolean,
                 aliases: '-d',
                 desc: 'Dry run',
                 default: false,
                 required: false
    class_option :store,
                 desc: 'The data store to connect to',
                 type: :string,
                 aliases: '-s',
                 enum: %w[mongodb postgresql]
    class_option :mongodb,
                 type: :boolean,
                 desc: 'Connect to the MongoDB data store'

    namespace :'lx-cli:db'

    def self.exit_on_failure?
      true
    end

    desc 'setup', 'Initialize the data stores for the project'
    def setup
      case current_store
      when 'mongodb'
        setup_mongodb
      else
        say "The data store '#{current_store}' is not supported", Thor::Shell::Color::RED
      end
    end

    desc 'connect', 'Connect to the data stores for the project'
    long_desc <<~DESC
      Connect to the data stores for the project. The connection details are read from the Rails credentials file.

      Example:
      $ bin/thor lx-cli:db:connect --store=mongodb

      For help with commands of a specific data store, use the --help option with the command.

      For example:
      $ bin/thor lx-cli:db:connect --store=mongodb --help
    DESC
    option :store,
           desc: 'The data store to connect to',
           type: :string,
           aliases: '-s',
           enum: %w[mongodb postgresql]
    option :help,
           type: :boolean,
           aliases: '-h',
           desc: 'Display usage information'
    def connect
      case current_store
      when 'mongodb'
        connect_to_mongodb
      else
        say "The data store '#{current_store}' is not supported", Thor::Shell::Color::RED
      end
    end

    private

    def connect_to_mongodb
      if options[:help]
        connect_cmd = 'docker exec -it mongodb.accounts.larcity mongosh --help'
        system connect_cmd, out: $stdout, err: :out
      elsif dry_run?
        say "\n(dry-run)", Thor::Shell::Color::MAGENTA
        output_msg = <<~DRY_RUN
          docker exec -it mongodb.accounts.larcity mongosh \
            --shell --authenticationDatabase admin \
            --username *** \
            --password ***
        DRY_RUN
        say output_msg, Thor::Shell::Color::YELLOW
      else
        connect_cmd = <<~CMD
          docker exec -it mongodb.accounts.larcity mongosh \
            --shell --authenticationDatabase admin \
            --username #{Rails.application.credentials.mongodb.user} \
            --password #{Rails.application.credentials.mongodb.password}
        CMD
        system connect_cmd, out: $stdout, err: :out
      end
    end

    def setup_mongodb
      # NOTE: This is the path to the initialization script within the docker container.
      #   This script is mounted from <rails_root>/db/development/mongodb/docker-entrypoint-initdb.d/init-doc-stores
      mongosh_script_path = '/docker-entrypoint-initdb.d/init-doc-stores.mongodb'

      # SO on manually filtering (hash) parameters: https://stackoverflow.com/a/6156581
      if dry_run? || verbose?
        say "\n(dry-run)", Thor::Shell::Color::MAGENTA if dry_run?
        output_msg = <<~DRY_RUN
          docker exec -it mongodb.accounts.larcity mongosh \
            --authenticationDatabase admin \
            --file #{mongosh_script_path} \
            --username *** \
            --password ***
        DRY_RUN
        say output_msg, Thor::Shell::Color::YELLOW
      end

      unless dry_run?
        init_mongodb_cmd = <<~CMD
          docker exec -it mongodb.accounts.larcity mongosh \
            --authenticationDatabase admin \
            --file #{mongosh_script_path} \
            --username #{Rails.application.credentials.mongodb.user} \
            --password #{Rails.application.credentials.mongodb.password}
        CMD
        system init_mongodb_cmd, out: $stdout, err: :out
      end
    end

    def current_store
      return 'mongodb' if mongodb?

      options[:store] || '<unknown>'
    end

    def mongodb?
      options[:mongodb] || options[:store] == 'mongodb'
    end

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end
  end
end
