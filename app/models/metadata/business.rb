# frozen_string_literal: true

module Metadata
  class Business
    include DocumentRecord

    field :account_id, type: String

    field :email, type: String

    validates :email, presence: true

    def business
      @business ||= Business.find_by(id: account_id)
    end
  end
end
