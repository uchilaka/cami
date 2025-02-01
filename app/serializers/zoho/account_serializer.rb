# frozen_string_literal: true

module Zoho
  class AccountSerializer < AdhocSerializer
    def attributes
      @attributes = { Email: email, Account_Name: company_name, Phone: phone_number }
      # @attributes[(has_mobile_number? ? 'Mobile' : 'Phone').to_sym] = phone_number
      # @attributes
    end

    def email
      object.email
    end

    def company_name
      object.display_name
    end

    def phone_number
      object.phone.try(:[], 'full_e164')
    end

    def phone_number_type
      object.phone.try(:[], 'number_type')
    end

    def serializable_hash(_options = nil)
      attributes
    end

    def has_mobile_number?
      phone_number_type == 'mobile'
    end
  end
end
