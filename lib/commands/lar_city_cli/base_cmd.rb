# frozen_string_literal: true

require 'thor'
require 'thor/shell/color'
require 'awesome_print'
require 'rbconfig'
require "#{Rails.root}/app/concerns/operating_system_detectable"
# require_relative '../../../app/concerns/operating_system_detectable'

# Conventions for command or task implementation classes:
# - Use the namespace method to define a namespace for the Thor class.
# - Use the desc method to define a description for the command.
# - Use the method_option method to define options for the command.
# - Use the say method to output text to the console.
# - All text verbose output should be in Thor::Shell::Color::MAGENTA.
module LarCityCLI
  class BaseCmd < Thor
    include OperatingSystemDetectable

    class_option :dry_run,
                 type: :boolean,
                 aliases: %w[-d --pretend --preview],
                 desc: 'Dry run',
                 default: false
    class_option :environment,
                 type: :string,
                 aliases: '--env',
                 desc: 'Environment',
                 required: false
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: false

    def self.exit_on_failure?
      true
    end

    protected

    def run(*args)
      cmd = args.join(' ')
      if verbose? || dry_run?
        msg = <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
        say(msg, dry_run? ? :magenta : :yellow)
      end
      return if dry_run?

      # # Example: doing this with Open3
      # Open3.popen2e(cmd) do |_stdin, stdout_stderr, wait_thread|
      #   Thread.new do
      #     stdout_stderr.each { |line| puts line }
      #   end
      #   wait_thread.value
      # end
      system(cmd, out: $stdout, err: :out)
    end

    def things(count)
      'item'.pluralize(count)
    end

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end
  end
end
