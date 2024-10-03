# frozen_string_literal: true

json.extract! account, :id, :display_name, :slug, :type, :readme, :status, :created_at, :updated_at
json.url account_url(account, format: :json)

case account
when Individual
  json.email account.email if account.user.present?
else
  # Assumes Business
  json.extract! account, :tax_id, :email
  json.email account.email if account.profile.present?
end

json.invoices account.invoices, partial: 'invoices/invoice', as: :invoice
