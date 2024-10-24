# frozen_string_literal: true

json.extract! account, :id, :display_name, :slug, :type, :readme, :status, :created_at, :updated_at
json.url account_url(account, format: :json)

json.actions do
  json.child! do
    json.label 'Edit'
    json.http_method 'GET'
    json.url account_url(account, format: :json)
  end
  json.child! do
    json.label 'Delete'
    json.http_method 'DELETE'
    json.url account_url(account, format: :json)
  end
  json.child! do
    json.label 'Back to accounts'
    json.http_method 'GET'
    json.url accounts_url
  end
end

if account.is_a?(Business)
  json.extract! account, :tax_id, :email
  json.email account.email if account.profile.present?
  json.profiles [account.profile].compact
  json.isVendor account.has_role?(:vendor)
end

if account.is_a?(Individual)
  json.email account.email if account.user.present?
  json.profiles account.profiles
end

json.invoices account.invoices, partial: 'invoices/invoice', as: :invoice
