# frozen_string_literal: true

require_relative 'base'

module LarCityCLI
  # Manage credentials for the rails app
  class KeyChain < Base
    class_option :environment,
                 type: :string,
                 aliases: '-e',
                 desc: 'Environment',
                 required: false

    namespace :'lx-cli:secrets'

    desc 'edit', 'Manage the secrets in the environment credentials file'
    option :editor,
           type: :string,
           aliases: '-a',
           desc: 'Editor to use',
           default: 'rubymine --wait',
           required: true
    def edit
      executable = Rails.root.join('bin', 'rails')
      command_to_run = "EDITOR=\"#{editor}\" bundle exec #{executable} credentials:edit --environment=#{environment}"

      puts "Will execute#{dry_run? ? ' (Dry-run)' : ''}: #{command_to_run}" if verbose? || dry_run?

      return if dry_run?

      system(command_to_run, out: $stdout)
    end

    # TODO: Add interactive :history command to peek into backup credential files
    desc 'backup', 'Backup an environment credentials file'
    long_desc <<~DESC
      Backup an environment credentials file. The backup file is saved
      in the config/credentials directory.

      This command supports the --environment option to specify the
      environment credentials file to backup. These files will also be
      saved with a timestamp in the filename and ignored when committing
      changes to source control.
    DESC
    def backup
      backup_file = Rails.root.join('config', 'credentials', "#{environment}--#{timestamp}.yml.enc")
      FileUtils.cp(credentials_file, backup_file, verbose: verbose?)

      say "Backed up #{credentials_file} to #{backup_file}", Color::GREEN
    end

    desc 'print_key', 'Print the contents of an input key file as a string'
    long_desc <<~DESC
      Print the contents of an input key file as a string. This is useful for copying the contents of a key file.

      Example:
        $ bin/thor lx-cli:secrets:print_key --key-file ~/.ssh/id_rsa
    DESC
    option :keyfile,
           type: :string,
           aliases: %w[-i --key-file],
           desc: 'Key file to print',
           required: true
    def print_key
      file_name = options[:keyfile].gsub(/^~/, ENV['HOME'])

      unless File.exist?(file_name)
        raise ActiveStorage::FileNotFoundError,
              "Key file not found: #{file_name}"
      end

      key_data = File.read(file_name)
      puts key_data.dump
    rescue ActiveStorage::FileNotFoundError => error
      puts error
    end

    private

    def timestamp(style: :url_safe)
      case style
      when :url_safe
        Time.now.strftime('%Y-%m-%dT%H%M%S')
      else
        Time.now.iso8601
      end
    end

    def rubymine?
      system('which rubymine')
    end

    def vscode?
      system('which code')
    end

    def environment
      @environment = options[:environment]
      @environment = Rails.env if @environment.blank?
      @environment
    end

    def credentials_file
      Rails.root.join('config', 'credentials', "#{environment}.yml.enc")
    end

    def editor
      return @editor if @editor.present?

      @editor = ENV.fetch('EDITOR', options[:editor])
      @editor ||= 'rubymine --wait' if rubymine?
      @editor ||= 'code --wait' if vscode?

      @editor ||= 'nano --wait'
    end
  end
end
