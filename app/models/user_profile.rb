# frozen_string_literal: true

class UserProfile
  include DocumentRecord

  field :user_id, type: String

  # Identity providers
  field :google, type: Hash
  field :facebook, type: Hash
  field :apple, type: Hash

  field :image_url, type: String
  field :last_seen_at, type: Time, default: -> { Time.now }

  validates :user_id, presence: true

  def user
    @user ||= User.find(user_id)
  end
end
