# frozen_string_literal: true

require 'thor'
require 'thor/shell/color'
require 'awesome_print'

# Conventions for command or task implementation classes:
# - Use the namespace method to define a namespace for the Thor class.
# - Use the desc method to define a description for the command.
# - Use the method_option method to define options for the command.
# - Use the say method to output text to the console.
# - All text verbose output should be in Thor::Shell::Color::MAGENTA.
module LarCityCLI
  class Base < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: false
    class_option :dry_run,
                 type: :boolean,
                 aliases: '-d',
                 desc: 'Dry run',
                 default: false

    def self.exit_on_failure?
      true
    end

    protected

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end
  end
end
