# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id            :uuid             not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :uuid
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  # Doc on polymorphic associations: https://guides.rubyonrails.org/association_basics.html#polymorphic-associations
  has_and_belongs_to_many :accounts, join_table: :accounts_roles
  # TODO: Add specs for these associations
  has_and_belongs_to_many :contacts,
                          join_table: :accounts_roles,
                          class_name: 'Account',
                          conditions: { accounts: { resource_type: 'Individual' } }
  # TODO: Add specs for these associations
  has_and_belongs_to_many :businesses,
                          join_table: :accounts_roles,
                          class_name: 'Account',
                          conditions: { accounts: { resource_type: 'Business' } }

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
