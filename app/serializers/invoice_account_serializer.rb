# frozen_string_literal: true

class InvoiceAccountSerializer < BaseSerializer
  def attributes
    if business?
      return {
        display_name: business_name,
        email:,
        type:
      }
    end

    {
      given_name:,
      family_name:,
      display_name:,
      email:,
      type:
    }
  end

  def given_name
    object.dig('billing_info', 'name', 'given_name')
  end

  def family_name
    object.dig('billing_info', 'name', 'family_name')
  end

  def display_name
    object.dig('billing_info', 'name', 'full_name')
  end

  def email
    object.dig('billing_info', 'email_address')
  end

  def business_name
    object.dig('billing_info', 'business_name')
  end

  def type
    business? ? 'Business' : 'Individual'
  end

  private

  def business?
    business_name.present?
  end
end
