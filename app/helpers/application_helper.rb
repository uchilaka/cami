# frozen_string_literal: true

module ApplicationHelper
  include StyleHelper

  # @deprecated Use `modal_dom_id` implemented in `AccountsHelper` or other
  #   more specific helpers instead.
  def modal_dom_id(resource, content_type: nil)
    return "#{resource.model_name.singular}--#{content_type}--modal|#{resource.id}|" if content_type.present?

    "#{resource.model_name.singular}-modal|#{resource.id}|"
  end

  def record_dom_id(resource, prefix: '')
    dom_id = "#{resource.model_name.singular}-row-#{resource.id}"
    if prefix.present?
      "#{prefix}--#{dom_id}"
    else
      dom_id
    end
  end

  def omniauth_authorize_path(_resource_name, _provider)
    user_google_omniauth_authorize_path
  end

  def page_title
    Rails.application.config.application_short_name ||
      Rails.application.class.module_parent_name
  end
end
