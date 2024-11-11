# frozen_string_literal: true

Fabricator(:user) do
  transient :phone_number

  email         { Faker::Internet.email }
  given_name    { Faker::Name.gender_neutral_first_name }
  family_name   { Faker::Name.last_name }
  password      { Faker::Internet.password(min_length: 8) }
  profile        do |attrs|
    phone_number = Phonelib.parse(attrs[:phone_number] || Faker::PhoneNumber.cell_phone)
    {
      image_url: Faker::Avatar.image,
      phone_e164: phone_number.e164,
      phone_country: phone_number.country
    }
  end

  after_build do |attrs|
    Fabricate.build(:identity_provider_profile, user_id: attrs.id)
  end
end

Fabricator(:user_with_provider_profiles, from: :user) do
  providers   { ['google'] }
  uids        { { 'google' => SecureRandom.alphanumeric(21) } }

  after_create do |attrs|
    attrs['providers'].map do |provider|
      uid = attrs.uids[provider] || SecureRandom.alphanumeric(21)
      Fabricate(:identity_provider_profile, uid:, user_id: attrs.id, provider:)
    end
  end
end
