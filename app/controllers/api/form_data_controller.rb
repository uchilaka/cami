# frozen_string_literal: true

module API
  class FormDataController < ApplicationController
    respond_to :json

    def countries
      @countries ||= self.class.country_list.sort_by { |c| c[:name] }
    end

    class << self
      def dial_codes_by_country
        @dial_codes_by_country ||=
          Rails
            .application
            .config_for(:regional_dial_codes)
            .each_with_object({}) do |v, h|
            dial_code, _name, alpha2 = v.values_at(:dial_code, :name, :code)
            h[alpha2] = { dial_code:, alpha2: }
            h
          end
      end

      def country_list
        @country_list ||=
          Rails
            .application
            .config_for(:countries)
            .map do |v|
            delimiter = /,\s+/
            alpha2 = v[:'alpha-2']
            name =
              if delimiter.match?(v[:name])
                v[:name].split(delimiter, 2).reverse.join(' ')
              else
                v[:name]
              end
            {
              name:,
              alpha2:,
              id: alpha2,
              dial_code: dial_codes_by_country.dig(alpha2, :dial_code)
            }
          end
      end
    end
  end
end
