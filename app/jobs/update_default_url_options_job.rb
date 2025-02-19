# frozen_string_literal: true

class UpdateDefaultURLOptionsJob < ApplicationJob
  sidekiq_options retry: 5,
                  # Skip sending it to the dead queue
                  dead: false

  attr_reader :routing_context

  def initialize(*)
    super
    @routing_context ||= :app
  end

  def perform(*_args)
    update_mailer_default_url_options
    update_controller_default_url_options
  end

  private

  def update_mailer_default_url_options
    log_baselines
    @routing_context = :mailer
    # Set the default_url_options for mailers
    Rails.configuration.action_mailer.default_url_options = VirtualOfficeManager.default_url_options
    # Check if the default_url_options have been updated
    Rails.logger.info("#{self.class.name} COMPARE: ActionMailer default_url_options", default_url_options:)
    # Check application-wide default_url_options
    Rails.logger.info(
      "#{self.class.name} COMPARE: Application default_url_options",
      default_url_options: Rails.application.default_url_options
    )
  end

  def update_controller_default_url_options
    log_baselines
    @routing_context = :controller
    # Set the default_url_options for mailers
    Rails.configuration.action_controller.default_url_options = VirtualOfficeManager.default_url_options
    # Check if the default_url_options have been updated
    Rails.logger.info("#{self.class.name} COMPARE: ActionController default_url_options", default_url_options:)
    # Check application-wide default_url_options
    Rails.logger.info(
      "#{self.class.name} COMPARE: Application default_url_options",
      default_url_options: Rails.application.default_url_options
    )
  end

  def log_baselines
    # Log the baseline for the default_url_options for ActionMailer
    Rails.logger.info("#{self.class.name} BASELINE: ActionController default_url_options", default_url_options:)
    @routing_context = :mailer
    # Log the baseline for the application-wide default_url_options
    Rails.logger.info("#{self.class.name} COMPARE: Application default_url_options", default_url_options:)
    # Set the routing context back to the app (default)
    @routing_context = :app
  end

  def default_url_options
    case routing_context
    when :mailer
      Rails.configuration.action_mailer.default_url_options
    else
      Rails.configuration.action_controller.default_url_options
    end
  end
end
