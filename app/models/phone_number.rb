# frozen_string_literal: true

# Embedded phone number for profile documents
class PhoneNumber
  include DocumentRecord

  field :value, type: String
  field :value_full_e164, type: String
  field :number_purpose, type: String
  field :number_type, type: String
  field :country, type: String

  validates :number_purpose, inclusion: { in: %w[personal business other] }
  validates :number_type, inclusion: { in: :supported_types }
  # Phonelib ActiveRecord integration:
  # https://github.com/daddyz/phonelib?tab=readme-ov-file#activerecord-integration
  validates :value,
            phone: {
              possible: true,
              allow_blank: false,
              country_specifier: ->(phone) { phone.country.try(:upcase) }
            }

  before_validation :parse_number_value_and_type

  def parse_number_value_and_type
    return if value.blank?

    phone = Phonelib.parse(value)
    self.country ||= phone.country
    self.value_full_e164 = phone.full_e164
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
