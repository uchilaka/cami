# frozen_string_literal: true

Fabricator(:invoice) do
  payment_vendor 'paypal'
  invoice_number do
    sequence(:invoice_number) do |n|
      "#{Time.now.strftime('%Y')}-INV#{(n + 1).to_s.rjust(5, '0')}"
    end
  end
  invoicer { { email_address: 'paypal@larcity.dev' } }
  accounts do
    [
      # Individual account
      {
        email: Faker::Internet.email,
        given_name: Faker::Name.gender_neutral_first_name,
        family_name: Faker::Name.last_name,
        type: 'Individual'
      },
      # Business account
      {
        email: Faker::Internet.email,
        display_name: Faker::Company.name,
        type: 'Business'
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
  payments { {} }
  links []
  note { Faker::Lorem.paragraph }
  vendor_record_id { SecureRandom.alphanumeric(20).upcase.scan(/.{4}/).join('-') }

  after_build do |invoice|
    # Generate random invoice amount
    dollars = rand(125..550)
    cents = rand(15..95) / 100.0
    value = NumberUtils.as_money(dollars + cents)
    if invoice.amount.nil? || invoice.amount[:value].nil?
      invoice.amount = { currency_code: invoice.currency_code, value: }
    end
    if invoice.due_amount.nil? || invoice.due_amount[:value].nil?
      invoice.due_amount = { currency_code: invoice.currency_code, value: }
    end
    # Compose account display names
    invoice.accounts.each do |account|
      next if account[:type] == 'Business'

      account[:display_name] = "#{account[:given_name]} #{account[:family_name]}"
    end
  end
end

Fabricator :paid_in_full_invoice, from: :invoice do
  status { 'PAID' }

  after_build do |invoice|
    invoice.payments = {
      paid_amount: {
        currency_code: invoice.currency_code,
        value: NumberUtils.as_money(invoice.amount[:value])
      }
    }
  end
end

Fabricator :partially_paid_invoice, from: :invoice do
  status { 'PARTIALLY_PAID' }

  after_build do |invoice|
    amount_value = invoice.amount[:value] * 0.75
    invoice.payments = {
      paid_amount: {
        currency_code: invoice.currency_code,
        value: NumberUtils.as_money(amount_value)
      }
    }
    invoice.due_amount = {
      currency_code: invoice.currency_code,
      value: NumberUtils.as_money(invoice.amount[:value] - amount_value)
    }
  end
end

Fabricator :viewed_invoice, from: :invoice do
  viewed_by_recipient true
end

Fabricator :overdue_invoice, from: :invoice do
  due_at { 1.week.ago }
end
