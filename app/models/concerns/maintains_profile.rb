# frozen_string_literal: true

module MaintainsProfile
  extend ActiveSupport::Concern

  included do
    after_create_commit :initialize_profile
    after_create_commit :save_profile, if: -> { profile.changed? }
    after_save_commit :save_profile, if: -> { profile.changed? }
    after_update_commit :save_profile, if: -> { profile.changed? }
    after_destroy_commit :destroy_profile

    def profile
      raise NotImplementedError
    end

    def initialize_profile
      raise NotImplementedError
    end

    def save_profile
      profile.save
    end

    def destroy_profile
      profile&.destroy
    end
  end
end
