# frozen_string_literal: true

# TODO: Add some examples and documentation on using this concern.
#   See implementation in User as a reference.
module MaintainsMetadata
  extend ActiveSupport::Concern

  included do
    after_create_commit :initialize_metadata
    after_create_commit :save_metadata, if: -> { metadata.changed? }
    after_save_commit :save_metadata, if: -> { metadata.changed? }
    after_update_commit :save_metadata, if: -> { metadata.changed? }
    after_destroy_commit :destroy_metadata

    def metadata
      raise NotImplementedError
    end

    def initialize_metadata
      raise NotImplementedError
    end

    def save_metadata
      metadata.save
    end

    def destroy_metadata
      metadata&.destroy
    end
  end
end
