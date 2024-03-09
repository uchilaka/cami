# frozen_string_literal: true

class UserProfile
  include DocumentRecord

  field :user_id, type: String
  field :identity_provider_user_id, type: String
  field :identity_provider, type: String
  field :last_seen_at, type: Time, default: -> { Time.now }

  validates :user_id, presence: true

  def user
    @user ||= User.find(user_id)
  end
end
