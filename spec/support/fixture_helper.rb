# frozen_string_literal: true

def load_lib_script(*script_rel_path_parts, ext: 'rb')
  script_rel_path = script_rel_path_parts.compact.join('/')
  load Rails.root.join('lib', "#{script_rel_path}.#{ext}")
end

def load_cli_script(script_name)
  load_lib_script('commands', 'lar-city-cli', script_name, ext:)
end
