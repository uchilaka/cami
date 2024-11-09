# frozen_string_literal: true

# Embedded phone number for profile documents
class PhoneNumber
  include DocumentRecord

  field :value, type: String
  field :full_e164, type: String
  field :full_international, type: String
  field :number_purpose, type: String
  field :number_type, type: String
  field :country, type: String

  # TODO: Figure out how to effectively validate the phone number
  #   without breaking the ability to save "good enough" partially
  #   validated records
  # validates :number_purpose, allow_nil: true, inclusion: { in: %w[personal business other] }
  # validates :number_type, allow_nil: true, inclusion: { in: :supported_types }
  # Phonelib ActiveRecord integration:
  # https://github.com/daddyz/phonelib?tab=readme-ov-file#activerecord-integration
  validates :value,
            phone: { possible: true, allow_blank: false },
            if: :should_validate_possibility?

  before_validation :parse_number_value_and_type

  def should_validate_possibility?
    Flipper.enabled?(:feat__validate_possible_phone_numbers)
  end

  def parse_number_value_and_type
    return if value.blank?

    phone = Phonelib.parse(value)
    self.country ||= phone.country
    self.full_e164 = phone.full_e164
    # TODO: Assert in spec that value == phone.full_international
    self.full_international = phone.full_international
    intersect_types = supported_types.intersection phone.types
    self.number_type = intersect_types.any? ? intersect_types.first : phone.types.first
  end

  def supported_types
    self.class.supported_types
  end

  class << self
    def supported_types
      %i[mobile fixed_line fixed_or_mobile personal_number fax other]
    end
  end
end
