# frozen_string_literal: true

Rails.application.configure do
  # Enable web console for all IP addresses (see https://stackoverflow.com/a/71292229)
  # To enable all IP v6 addresses, use '::/0'
  # config.web_console.permissions = '0.0.0.0/0'

  config.web_console.permissions = VirtualOfficeManager.web_console_permissions
end
