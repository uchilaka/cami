# frozen_string_literal: true

module Zoho
  class UpsertAccountJob
    include AfterCommitEverywhere

    attr_accessor :account

    def call
      Account.transaction do
        # account.save!
        after_commit do
          Zoho::API::Account.upsert(account)
        end
      end
    end

    def perform(*_args)
      Rails.logger.info 'Upserting Zoho account record', args: _args
    end
  end
end
