# frozen_string_literal: true

require_relative 'base'
require 'fileutils'

module LarCityCLI
  # Manage data stores for the project
  class DataStores < Base
    class_option :store,
                 desc: 'The data store to connect to',
                 type: :string,
                 aliases: '-s',
                 enum: %w[mongodb postgresql postgres psql]
    class_option :mongodb,
                 type: :boolean,
                 desc: 'Connect to the MongoDB data store'
    class_option :postgres,
                 type: :boolean,
                 desc: 'Connect to the PostgreSQL data store'

    namespace :'lx-cli:db'

    desc 'setup', 'Initialize the data stores for the project'
    def setup
      case current_store
      when 'mongodb'
        setup_mongodb
      when 'postgres'
        setup_postgres
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
           enum: %w[mongodb postgresql postgres psql]
    option :help,
           type: :boolean,
           aliases: '-h',
           desc: 'Display usage information'
    option :user,
           type: :string,
           desc: 'The username to use for the connection'
    option :name,
           type: :string,
           desc: 'The data store name to connect to'
    def connect
      case current_store
      when 'mongodb'
        connect_to_mongodb
      when 'postgres'
        connect_to_postgres
      else
        say "The data store '#{current_store}' is not supported", Thor::Shell::Color::RED
      end
    end

    private

    def database_name
      return options[:name] if options[:name].present?

      case current_store
      when 'postgres'
        "account_manager_#{Rails.env}"
      when 'mongodb'
        "doc_store_#{Rails.env}"
      else
        ENV.fetch('APP_DATABASE_NAME')
      end
    end

    def username
      options[:user] || ENV.fetch('APP_DATABASE_USER')
    end

    def set_variables_from_options
      options.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def connect_to_postgres
      if options[:help]
        connect_cmd = 'docker exec -it db.accounts.larcity psql --help'
        system connect_cmd, out: $stdout, err: :out
      elsif dry_run?
        say "\n(dry-run)", Thor::Shell::Color::MAGENTA
        output_msg = <<~DRY_RUN
          #{postgres_connect_cmd_prefix} --username=*** --no-password
        DRY_RUN
        say output_msg, Thor::Shell::Color::YELLOW
      else
        connect_cmd = <<~CMD
          #{postgres_connect_cmd_prefix} --username=#{username} --no-password
        CMD
        say 'Connecting to the PostgreSQL database...', Thor::Shell::Color::YELLOW
        say connect_cmd, Thor::Shell::Color::MAGENTA if verbose?
        system connect_cmd, out: $stdout, err: :out
      end
    end

    def setup_postgres
      if dry_run? || verbose?
        say "\n(dry-run)", Thor::Shell::Color::MAGENTA if dry_run?
        output_msg = <<~DRY_RUN
          #{postgres_connect_cmd_prefix} --username=*** --no-password --file /docker-entrypoint-initdb.d/create_role.sql
        DRY_RUN
        say output_msg, Thor::Shell::Color::YELLOW
      end

      return if dry_run?

      init_postgres_cmd = <<~CMD
        #{postgres_connect_cmd_prefix} --username=#{username} --no-password --file /docker-entrypoint-initdb.d/create_role.sql
      CMD
      system init_postgres_cmd, out: $stdout, err: :out
    end

    def postgres_connect_cmd_prefix
      "docker exec -it db.accounts.larcity psql --host=localhost --dbname=#{database_name}"
    end

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
        say 'Connecting to the MongoDB database...', Thor::Shell::Color::YELLOW
        say connect_cmd, Thor::Shell::Color::MAGENTA if verbose?
        system connect_cmd, out: $stdout, err: :out
      end
    end

    def setup_mongodb
      # NOTE: This is the path to the initialization script within the docker container.
      #   This script is mounted from <rails_root>/db/development/mongodb/docker-entrypoint-initdb.d/init-doc-stores
      mongosh_script_path = '/docker-entrypoint-initdb.d/init-doc-stores.js'

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

      return if dry_run?

      init_mongodb_cmd = <<~CMD
        docker exec -it mongodb.accounts.larcity mongosh \
          --authenticationDatabase admin \
          --file #{mongosh_script_path} \
          --username #{Rails.application.credentials.mongodb.user} \
          --password #{Rails.application.credentials.mongodb.password}
      CMD
      system init_mongodb_cmd, out: $stdout, err: :out
    end

    def current_store
      return 'mongodb' if mongodb?
      return 'postgres' if postgres?

      options[:store] || '<unknown>'
    end

    def mongodb?
      options[:mongodb] || options[:store] == 'mongodb'
    end

    def postgres?
      options[:postgres] || %w[postgres postgresql psql].include?(options[:store])
    end
  end
end
