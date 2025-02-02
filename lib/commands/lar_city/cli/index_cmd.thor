# frozen_string_literal: true

require_relative '../../lar_city_cli/base_cmd'
require_relative '../../lar_city_cli/datakit_cmd'
require_relative '../../lar_city_cli/devkit_cmd'
require_relative '../../lar_city_cli/secrets_cmd'
require_relative '../../lar_city_cli/tunnel_cmd'

module LarCity
  module CLI
    class IndexCmd < LarCityCLI::BaseCmd
      namespace 'lx-cli'

      desc 'secrets [SUBCOMMAND]', 'Manage the secrets in the environment credentials file'
      subcommand 'secrets', LarCityCLI::SecretsCmd

      desc 'devkit [SUBCOMMAND]', 'A few developer tools for the project'
      subcommand 'devkit', LarCityCLI::DevkitCmd

      desc 'datakit [SUBCOMMAND]', 'A few tools for managing application data stores'
      subcommand 'datakit', LarCityCLI::DatakitCmd

      desc 'tunnel [SUBCOMMAND]', 'Manage the dev proxy tunnel (for testing the app with a public URL)'
      subcommand 'tunnel', LarCityCLI::TunnelCmd
    end
  end
end
