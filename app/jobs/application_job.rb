# frozen_string_literal: true

require 'awesome_print'

# To setup as ActiveJob, see: https://github.com/sidekiq/sidekiq/wiki/Active-Job#active-job-setup
class ApplicationJob
  include Sidekiq::Job

  queue_as :default

  # For Sidkiq error handing, see: https://github.com/sidekiq/sidekiq/wiki/Error-Handling
  sidekiq_options retry: 3

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
