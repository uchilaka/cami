# frozen_string_literal: true

require_relative '../../lib/commands/lar_city_cli/tunnel_cmd'

LarCityCLI::TunnelCmd.new.invoke(:init, [], verbose: Rails.env.development?)
