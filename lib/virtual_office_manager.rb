# frozen_string_literal: true

# This class is intended to facilitate access to business related
#   defaults and information with support for retrieving
#   data from secure or encrypted sources.
class VirtualOfficeManager
  class << self
    def default_entity
      Rails.application.credentials&.entities&.larcity
    end
  end
end
