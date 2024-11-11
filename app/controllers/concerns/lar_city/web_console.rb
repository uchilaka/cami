# frozen_string_literal: true

module LarCity
  module WebConsole
    extend ActiveSupport::Concern

    included do
      before_action :initialize_web_console, only: supported_actions
    end

    module ClassMethods
      def load_console(actions = supported_actions, options = {})
        [*actions].flatten.each { |action| authorized_actions[action] = options }

        before_action :initialize_web_console, only: authorized_actions.keys
      end

      def authorized_actions
        @authorized_actions ||= {}.with_indifferent_access
      end

      def supported_actions
        %i[index new show edit]
      end
    end

    def initialize_web_console
      console if current_user&.admin? || Rails.env.development?
    end
  end
end
