# frozen_string_literal: true

# 20241110062259_add_name_fields_to_users.rb
class AddNameFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :given_name, :string
    add_column :users, :family_name, :string
  end
end
