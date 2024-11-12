# frozen_string_literal: true

module UsersHelper
  def avatar_url(_user)
    # TODO: Create a metadata (aliased as profile) field in the user model
    #   and store the image_url there
    # return user.profile.image_url if user_signed_in?

    image_url 'person-default.svg'
  end
end
