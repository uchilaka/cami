# frozen_string_literal: true

module ProfilesHelper
  include UserProfileHelper

  def modal_dom_id(resource, content_type: nil)
    if profile_summary_modal_enabled? && content_type == 'summary'
      return "#{resource.class.table_name.singularize}--#{content_type}-modal"
    end

    super
  end

  def profile_status_enabled?
    Flipper.enabled?(:feat__profile_status, current_user)
  end

  def profile_summary_modal_enabled?
    Flipper.enabled?(:feat__profile_summary_modal, current_user)
  end

  def profile_editor_modal_enabled?
    Flipper.enabled?(:feat__profile_editor_modal, current_user)
  end
end
