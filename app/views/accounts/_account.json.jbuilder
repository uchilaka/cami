json.extract! account, :id, :display_name, :slug, :status, :type, :tax_id, :email, :readme, :created_at, :updated_at

json.url account_url(account, format: :json)

json.actions model_actions(account)

json.actions_list model_actions(account).entries do |action_key, action|
  json.key action_key
  json.dom_id action[:dom_id]
  json.http_method action[:http_method]
  json.label action[:label]
  json.url action[:url]
end

json.is_vendor account.has_role?(:vendor)

# json.invoices account.invoices, partial: 'invoices/invoice', as: :invoice
