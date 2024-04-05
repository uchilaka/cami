# frozen_string_literal: true

class BusinessProfile
  include DocumentRecord

  field :account_id, type: String

  field :email, type: String

  validates :email, presence: true
end
