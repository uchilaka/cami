# frozen_string_literal: true

json.extract! account, :id, :display_name, :slug, :type, :readme, :status, :created_at, :updated_at
json.url account_url(account, format: :json)

json.actions model_actions(account)

json.actions_list model_actions(account).entries do |action_key, action|
  json.key action_key
  json.dom_id action[:dom_id]
  json.http_method action[:http_method]
  json.label action[:label]
  json.url action[:url]
end

if account.is_a?(Business)
  json.extract! account, :tax_id, :email
  json.email account.email if account.profile.present?
  json.profiles do
    json.child! do
      json.partial! 'profiles/metadata_profile', metadata_profile: account.profile, account:
    end
  end
  json.isVendor account.has_role?(:vendor)
elsif account.is_a?(Individual)
  json.email account.email if account.user.present?
  json.profiles account.profiles, partial: 'profiles/metadata_profile', as: :metadata_profile, account:
else
  json.profiles []
end

json.invoices account.invoices, partial: 'invoices/invoice', as: :invoice
