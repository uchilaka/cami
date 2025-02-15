# frozen_string_literal: true

json.extract! account, :id, :display_name, :slug, :status, :type, :tax_id, :email,
              :created_at, :updated_at, :actions

json.readme do
  json.html account.readme.to_s
  json.plaintext account.readme.to_plain_text
end
json.url account_url(account, format: :json)

# json.actions account.actions

json.actions_list account.actions.entries do |action_key, action|
  json.key action_key
  json.dom_id action[:dom_id]
  json.http_method action[:http_method]
  json.label action[:label]
  json.url action[:url]
end

json.is_vendor account.has_role?(:vendor)

# json.invoices account.invoices, partial: 'invoices/invoice', as: :invoice
