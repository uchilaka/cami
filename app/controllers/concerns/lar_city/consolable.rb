# frozen_string_literal: true

module LarCity
  module Consolable
    extend ActiveSupport::Concern

    module ClassMethods
      def load_console(actions = supported_actions, options = {})
        [*actions].each { |action| authorized_actions[action] = options }

        before_action :initialize_web_console, only: authorized_actions.keys
      end

      def authorized_actions
        @authorized_actions ||= {}.with_indifferent_access
      end

      def supported_actions
        %i[index show new edit create update destroy]
      end
    end

    def initialize_web_console
      console
    end
  end
end
