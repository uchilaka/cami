# frozen_string_literal: true

module Renderable
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    include InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def modal_dom_id(resource = nil, content_type: nil)
      resource ||= self if self.class.ancestors.include?(ActiveRecord::Base)
      return "#{resource.model_name.singular}--#{content_type}--modal|#{resource.id}|" if content_type.present?

      "#{resource.model_name.singular}-modal|#{resource.id}|"
    end
  end
end
