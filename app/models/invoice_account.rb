# frozen_string_literal: true

class InvoiceAccount
  include DocumentRecord

  embedded_in :invoice, inverse_of: :accounts

  field :display_name, type: String
  field :given_name, type: String
  field :family_name, type: String
  field :email, type: String
  field :type, type: String

  validates :display_name, presence: true
  validates :type, presence: true, inclusion: { in: %w[Business Individual] }
end
