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
    def modal_dom_id(*_args)
      raise NotImplementedError, "#{self.class.name} must implement #modal_dom_id"
    end
  end
end
