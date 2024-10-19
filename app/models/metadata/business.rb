# frozen_string_literal: true

module Metadata
  class Business
    include DocumentRecord

    field :account_id, type: String
    field :email, type: String

    embeds_one :phone, class_name: 'PhoneNumber'

    validates :account_id, presence: true, uniqueness: { case_sensitive: false }
    validates :email, allow_nil: true, email: true
    validate :should_have_email_or_phone_number, on: :update

    before_save :save_phone_number, if: -> { phone&.changed? }

    def phone=(value)
      number = PhoneNumber.new(value:)
      number.validate
      if number.valid?
        number.save
        set(phone: number)
      else
        errors.add(:phone, number.errors.full_messages.join(', '))
      end
    end

    def business
      @business ||= ::Business.find_by(id: account_id)
    end

    def save_phone_number
      phone.save
    end

    def should_have_email_or_phone_number
      return unless email.blank? && phone.blank?

      errors.add(:base, I18n.t('models.metadata.business.errors.should_have_email_or_phone_number'))
      errors.add(:phone, I18n.t('models.metadata.business.errors.should_have_email_or_phone_number'))
      errors.add(:email, I18n.t('models.metadata.business.errors.should_have_email_or_phone_number'))
    end
  end
end
