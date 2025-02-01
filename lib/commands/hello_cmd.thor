# frozen_string_literal: true

require 'thor'
require 'thor/shell/color'

class HelloCmd < Thor
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
    say "👋🏽 Hello, #{options[:name]}!", :magenta
  end
end
