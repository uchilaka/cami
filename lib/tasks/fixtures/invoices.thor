# frozen_string_literal: true

require_relative '../../commands/lar_city_cli/base'

module Fixtures
  class Invoices < LarCityCLI::Base
    desc 'load', 'Load invoice fixtures'
    def load
      # Load paypal invoices
    end
  end
end
