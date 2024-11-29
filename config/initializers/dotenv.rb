# frozen_string_literal: true

# See https://github.com/bkeepers/dotenv?tab=readme-ov-file#customizing-rails
dotenv_required_keys = %w[
  ADMIN_REMOTE_IP_ADDRESSES
  APP_DATABASE_NAME
  APP_DATABASE_USER
  APP_DATABASE_PASSWORD
  LAN_SUBNET_MASK
  PORT
  REDIS_URL
]

if Rails.env.test?
  %w[
    ADMIN_REMOTE_IP_ADDRESSES
    LAN_SUBNET_MASK
  ].each { |key| dotenv_required_keys.delete key }
end

if Rails.env.development?
  dotenv_required_keys.unshift 'NGROK_PROFILE_CONFIG_PATH',
                               'NGROK_AUTH_TOKEN',
                               'APP_DATABASE_PORT'
end

Dotenv.require_keys(*dotenv_required_keys)
