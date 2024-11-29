# frozen_string_literal: true

unless Rails.env.test?
  config_file_template = Rails.root.join('config', 'ngrok.yml.erb')
  # Process an ERB config file if one is found
  if File.exist?(config_file_template)
    config_file = Rails.root.join('config', 'ngrok.yml')
    unless File.exist?(config_file)
      puts 'Processing ngrok config ERB...'
      yaml_config = ERB.new(File.read(config_file_template)).result
      puts "Writing ngrok config to #{config_file}"
      File.write config_file, yaml_config
    end
  end
end
