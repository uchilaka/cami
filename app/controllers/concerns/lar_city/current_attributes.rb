# frozen_string_literal: true

module LarCity
  module CurrentAttributes
    extend ActiveSupport::Concern

    included do
      before_action :maybe_set_current_attributes
    end

    private

    def maybe_set_current_attributes
      return if excluded_controllers.include?(request.params[:controller])

      Current.user = current_user
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    def excluded_controllers
      # E.g. controller for magic links: devise/magic_links
      []
    end
  end
end
