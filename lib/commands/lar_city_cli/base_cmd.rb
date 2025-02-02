# frozen_string_literal: true

require 'thor'
require 'thor/shell/color'
require 'awesome_print'
require 'rbconfig'
require_relative '../../lar_city/errors'

# Conventions for command or task implementation classes:
# - Use the namespace method to define a namespace for the Thor class.
# - Use the desc method to define a description for the command.
# - Use the method_option method to define options for the command.
# - Use the say method to output text to the console.
# - All text verbose output should be in Thor::Shell::Color::MAGENTA.
module LarCityCLI
  class BaseCmd < Thor
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

    def things(count)
      'item'.pluralize(count)
    end

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end

    # Check OS with Ruby: https://gist.github.com/havenwood/4161944
    def mac?
      friendly_os_name == :macos
    end

    def linux?
      friendly_os_name == :linux
    end

    def friendly_os_name
      case RbConfig::CONFIG['host_os']
      when /linux/
        :linux
      when /darwin/
        :macos
      when /mswin|mingw32|windows/
        :windows
      when /solaris/
        :solaris
      when /bsd/
        :bsd
      else
        :unsupported
      end
    end

    def human_friendly_os_names_map
      {
        linux: 'Linux',
        macos: 'macOS',
        windows: 'Windows',
        solaris: 'Solaris',
        bsd: 'BSD',
        unsupported: 'Unsupported'
      }
    end
  end
end
