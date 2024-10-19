# frozen_string_literal: true

module Metadata
  class Business
    include DocumentRecord

    field :account_id, type: String
    field :email, type: String

    embeds_one :phone, class_name: 'PhoneNumber'

    validates :account_id, presence: true, uniqueness: { case_sensitive: false }
    validates :email, allow_nil: true, email: true
    validate :should_have_email_or_phone_number

    def business
      @business ||= ::Business.find_by(id: account_id)
    end

    def should_have_email_or_phone_number
      errors.add(:base, 'Business must have either an email or a phone number') if email.blank? && phone.blank?
    end
  end
end
