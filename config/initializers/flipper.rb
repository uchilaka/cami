# frozen_string_literal: true

require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.adapter do
    # See https://www.flippercloud.io/docs/adapters/redis#usage
    Flipper::Adapters::Redis.new(
      Redis.new(Rails.application.credentials.redis.options.to_h)
    )
  end
end

Rails.application.config.after_initialize do |app|
  app.config_for(:features).each do |feature, options|
    Flipper.enable(feature) if options[:enabled]
  end
end
