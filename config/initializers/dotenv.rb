# frozen_string_literal: true

# See https://github.com/bkeepers/dotenv?tab=readme-ov-file#customizing-rails
dotenv_required_keys = %w[
  PORT
  APP_DATABASE_NAME
  APP_DATABASE_USER
  APP_DATABASE_PASSWORD
  ADMIN_REMOTE_IP_ADDRESSES
]

%w[ADMIN_REMOTE_IP_ADDRESSES].each { |key| dotenv_required_keys.delete key } if Rails.env.test?

if Rails.env.development?
  dotenv_required_keys.unshift 'NGROK_PROFILE_CONFIG_PATH',
                               'NGROK_AUTH_TOKEN',
                               'APP_DATABASE_PORT'
end

Dotenv.require_keys(*dotenv_required_keys)
