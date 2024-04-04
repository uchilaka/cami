# frozen_string_literal: true

# See https://github.com/bkeepers/dotenv?tab=readme-ov-file#customizing-rails
dotenv_required_keys = %w[
  APP_DATABASE_NAME
  APP_DATABASE_USER
  APP_DATABASE_PASSWORD
  MONGODB_USERNAME
  MONGODB_PASSWORD
  MONGODB_DATABASE
  MONGODB_PORT
]

if Rails.env.test?
  dotenv_required_keys.delete 'MONGODB_USERNAME'
  dotenv_required_keys.delete 'MONGODB_PASSWORD'
  dotenv_required_keys.delete 'ADMIN_REMOTE_IP_ADDRESSES'
  dotenv_required_keys.unshift 'MONGODB_TEST_PORT' \
    unless Rails.application.credentials.mongodb.port.present?
end

if Rails.env.development?
  dotenv_required_keys.unshift 'NGROK_PROFILE_CONFIG_PATH',
                               'NGROK_AUTH_TOKEN',
                               'APP_DATABASE_PORT'
end

Dotenv.require_keys(*dotenv_required_keys)
