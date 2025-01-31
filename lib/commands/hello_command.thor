# frozen_string_literal: true

require 'thor'
require 'thor/shell/color'

class HelloCommand < Thor
  namespace 'demo'

  def self.exit_on_failure?
    true
  end

  desc 'hello', 'Say hello to [--name NAME]!'
  option :name,
         desc: 'Name to say hello to',
         type: :string,
         aliases: %w[-n --name],
         default: 'world',
         required: false
  def hello
    # Using a non-command helper method
    os_support_clause = "You're running on #{friendly_os_name}!" if friendly_os_name != :unsupported
    # Putting it all together ...in style
    say "👋🏽 Hello, #{options[:name]}! #{os_support_clause}", :magenta
  end

  no_commands do
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
  end
end
