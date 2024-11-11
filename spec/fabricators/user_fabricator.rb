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
end

Fabricator(:user_with_provider_profiles, from: :user) do
  providers   { %w[google apple whatsapp] }
  uids        do
    {
      'google' => SecureRandom.alphanumeric(21),
      'apple' => SecureRandom.alphanumeric(21),
      'whatsapp' => SecureRandom.alphanumeric(21)
    }
  end

  after_create do |user|
    user.providers.each do |provider|
      user.uids[provider] ||= SecureRandom.alphanumeric(21)
      Fabricate(:identity_provider_profile, uid: user.uids[provider], user:, provider:)
    end
    user.save!
  end
end
