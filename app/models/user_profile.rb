# frozen_string_literal: true

class UserProfile
  include ActiveModel::API
  include ActiveModel::Serialization
  extend ActiveModel::Callbacks
  include ActiveModel::Dirty

  attr_accessor :image_url,
                :phone_e164,
                :phone_country_code

  def attributes
    {
      image_url: nil,
      phone_e164: nil,
      phone_country_code: nil
    }
  end
end
