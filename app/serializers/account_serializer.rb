# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  metadata     :jsonb
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
class AccountSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :slug,
             :status, :type, :tax_id, :notes_as_html

  # Read more on rendering rich text content:
  # https://guides.rubyonrails.org/action_text_overview.html#rendering-rich-text-content
  def notes_as_html
    object.readme.to_s
  end
end
