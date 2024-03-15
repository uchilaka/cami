# frozen_string_literal: true

module ApplicationHelper
  def omniauth_authorize_path(_resource_name, _provider)
    user_google_omniauth_authorize_path
  end
end
