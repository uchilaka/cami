# frozen_string_literal: true

module LarCity
  class ApplicationRouteConstraint
    protected

    def log_prefix(method_name)
      "#{self.class.name}##{method_name}"
    end
  end
end
