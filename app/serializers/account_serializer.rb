class AccountSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :slug, :status, :type, :tax_id, :readme
end
