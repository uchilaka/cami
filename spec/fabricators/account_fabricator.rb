# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
Fabricator(:account) do
  display_name "MyString"
  slug         "MyString"
  status       1
  type         ""
  tax_id       "MyString"
  readme       "MyText"
end
