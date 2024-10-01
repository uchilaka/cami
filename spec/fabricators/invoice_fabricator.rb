# frozen_string_literal: true

Fabricator(:invoice) do
  payment_vendor 'paypal'
  invoice_number do
    sequence(:invoice_number) do |n|
      "#{Time.now.strftime('%Y')}-INV#{(n + 1).to_s.rjust(5, '0')}"
    end
  end
  invoicer { { email_address: 'paypal@larcity.dev' } }
  # accounts { [Fabricate(:individual_invoice_account), Fabricate(:business_invoice_account)] }
  accounts do
    [
      # Individual invoice account
      {
        type: 'Individual',
        given_name: Faker::Name.neutral_first_name,
        family_name: Faker::Name.last_name,
        email: Faker::Internet.email
      },
      # Business invoice account
      {
        type: 'Business',
        display_name: Faker::Company.name,
        email: Faker::Internet.email
      }
    ]
  end
  viewed_by_recipient false
  invoiced_at { Time.now }
  due_at { Time.now }
  updated_accounts_at { nil }
  currency_code 'USD'
  # Payment vendor documentation for invoice status:
  # https://developer.paypal.com/docs/api/invoicing/v2/#definition-invoice_status
  status { 'SENT' }
  links []
  note { Faker::Lorem.paragraph }
  vendor_record_id { SecureRandom.alphanumeric(20).upcase.scan(/.{4}/).join('-') }

  after_build do |invoice|
    # Compose account display names
    invoice.accounts.each do |account|
      next if account[:type] == 'Business'

      account[:display_name] = "#{account[:given_name]} #{account[:family_name]}"
    end
  end
end

Fabricator :invoice_with_amounts, from: :invoice do
  after_build do |invoice|
    # Generate random invoice amount
    dollars = rand(125..550)
    cents = rand(15..95) / 100.0
    value = dollars + cents
    invoice.amount ||= { currency_code: invoice.currency_code, value: }
    invoice.due_amount ||= { currency_code: invoice.currency_code, value: }
  end
end

Fabricator :paid_in_full_invoice, from: :invoice_with_amounts do
  status { 'PAID' }

  after_build do |invoice|
    invoice.payments = [
      { currency_code: invoice.currency_code, value: invoice.amount[:value] }
    ]
    invoice.save!
  end
end

Fabricator :partially_paid_invoice, from: :invoice_with_amounts do
  status { 'PARTIALLY_PAID' }

  after_build do |invoice|
    amount_value = invoice.amount[:value] * 0.75
    invoice.payments = [
      { currency_code: invoice.currency_code, value: amount_value }
    ]
    invoice.due_amount = {
      currency_code: invoice.currency_code,
      value: invoice.amount[:value] - amount_value
    }
    invoice.save!
  end
end

Fabricator :viewed_invoice, from: :invoice_with_amounts do
  viewed_by_recipient true
end

Fabricator :overdue_invoice, from: :invoice_with_amounts do
  due_at { 1.week.ago }
end
