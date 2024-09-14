# frozen_string_literal: true

if Rails.env.development?
  LetterOpener.configure do |config|
    # To overrider the location for message storage.
    # Default value is `tmp/letter_opener`
    config.location = Rails.root.join('tmp', 'email', 'inbox')
    # To render only the message body, without any metadata or extra containers or styling.
    # Default value is `:default` that renders styled message with showing useful metadata.
    config.message_template = :light
    # Set the file URI scheme for macOS
    # config.file_uri_scheme = 'file://'
  end
end
