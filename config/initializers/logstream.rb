# frozen_string_literal: true

Rails.configuration.before_initialize do
  LogUtils.initialize_stream unless Rails.env.test? || LogUtils.streaming_via_http?
end
