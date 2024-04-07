# frozen_string_literal: true

module Metadata
  class Profile
    include DocumentRecord

    field :user_id, type: String

    # Identity providers
    field :google, type: Hash
    field :facebook, type: Hash
    field :apple, type: Hash

    field :image_url, type: String
    field :last_seen_at, type: Time, default: -> { Time.now }

    validates :user_id, presence: true, uniqueness: { case_sensitive: false }

    def user
      @user ||= User.find_by(id: user_id)
    end
  end
end
