# frozen_string_literal: true

module UsersHelper
  def avatar_url(user)
    return user.profile.image_url if user_signed_in?

    image_url 'person-default.svg'
  end
end
