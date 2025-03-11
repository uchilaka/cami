# frozen_string_literal: true

module Zoho
  class UpsertAccountJob < ApplicationJob
    queue_as :critical

    attr_accessor :account

    def perform(id)
      Rails.logger.info 'Upserting Zoho account record for account', id:
    end
  end
end
