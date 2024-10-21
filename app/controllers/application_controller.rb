# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include LarCity::CurrentAttributes
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :public_resource?
  # For more on action controller filters, see https://guides.rubyonrails.org/action_controller_overview.html#filters
  before_action :initialize_web_console, only: %i[index new show edit], if: -> { Rails.env.development? }

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :name, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :name, :email, :password, :password_confirmation, :current_password)
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || pages_dashboard_path
  end

  protected

  def public_resource?
    %w[/up].include?(request.path)
  end

  def initialize_web_console
    console
  end
end
