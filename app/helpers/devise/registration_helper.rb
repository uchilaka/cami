# frozen_string_literal: true

module Devise
  module RegistrationHelper
    def supported_roles
      # TODO: In the future, look at resource_name to determine what
      #   values to return
      return {} unless resource_name == :user

      User::SUPPORTED_ROLES
    end
  end
end
