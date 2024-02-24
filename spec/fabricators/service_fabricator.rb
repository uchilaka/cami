# frozen_string_literal: true

# == Schema Information
#
# Table name: services
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  readme       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
Fabricator(:service) do
  display_name 'MyString'
  readme       'MyText'
end
