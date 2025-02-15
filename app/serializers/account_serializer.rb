# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                :uuid             not null, primary key
#  display_name      :string
#  email             :string
#  metadata          :jsonb
#  phone             :jsonb
#  readme            :text
#  slug              :string
#  status            :integer
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_account_id :uuid
#  remote_crm_id     :string
#  tax_id            :string
#
# Foreign Keys
#
#  fk_rails_...  (parent_account_id => accounts.id)
#
class AccountSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :slug, :email,
             :status, :type, :tax_id, :notes_as_html,
             :created_at, :updated_at, :actions, :actions_list

  # Read more on rendering rich text content:
  # https://guides.rubyonrails.org/action_text_overview.html#rendering-rich-text-content
  def notes_as_html
    object.readme.to_s
  end

  def actions
    object.actions
  end

  def actions_list
    object.actions_as_list
  end
end
