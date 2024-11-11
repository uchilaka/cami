# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
class AccountSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :slug, :status, :type, :tax_id, :readme
end
