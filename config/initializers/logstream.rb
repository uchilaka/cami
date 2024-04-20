# frozen_string_literal: true

Rails.configuration.after_initialize do
  LogUtils.initialize_stream unless Rails.env.test? || LogUtils.streaming_via_http?
end
