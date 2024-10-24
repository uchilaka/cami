# frozen_string_literal: true

json.array! @metadata_profiles, partial: 'metadata_profiles/metadata_profile', as: :metadata_profile
