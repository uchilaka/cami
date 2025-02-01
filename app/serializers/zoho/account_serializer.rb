# frozen_string_literal: true

module Zoho
  class AccountSerializer < AdhocSerializer
    def attributes
      {
        Email: email,
        Account_Name: company_name
      }
    end

    def email
      object['email']
    end

    def company_name
      object['display_name']
    end

    def serializable_hash(_options = nil)
      attributes
    end
  end
end
