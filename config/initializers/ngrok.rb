# frozen_string_literal: true

load Rails.root.join('lib/commands/lar_city_cli/tunnel.thor')

LarCityCLI::Tunnel.new.invoke(:init, [], verbose: Rails.env.development?)
