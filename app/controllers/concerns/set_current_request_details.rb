# frozen_string_literal: true

module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      unless excluded_controllers.include?(request.params[:controller])
        Current.user = current_user
        Current.request_id = request.uuid
        Current.user_agent = request.user_agent
        Current.ip_address = request.ip
      end
    end

    private

    def excluded_controllers
      %w[
        devise/magic_links
      ]
    end
  end
end
