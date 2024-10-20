# frozen_string_literal: true

# Process an ERB config file if one is found
config_file_template = Rails.root.join('config', 'ngrok.yml.erb')
if File.exist?(config_file_template)
  puts 'Processing ngrok config ERB...'
  config_file = Rails.root.join('config', 'ngrok.yml')
  yaml_config = ERB.new(File.read(config_file_template)).result
  puts "Writing ngrok config to #{config_file}"
  File.write config_file, yaml_config
end
