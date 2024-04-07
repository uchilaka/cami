# frozen_string_literal: true

# This class is intended to facilitate access to business related
#   defaults and information with support for retrieving
#   data from secure or encrypted sources.
class VirtualOfficeManager
  class << self
    def default_entity
      Rails.application.credentials&.entities&.larcity
    end

    def entities
      Rails.application.credentials&.entities
    end

    def entity_by_key(entity_key)
      return nil if entity_key.blank?

      entities&.send(entity_key)
    end
  end
end
