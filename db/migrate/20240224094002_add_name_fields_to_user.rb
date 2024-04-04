# frozen_string_literal: true

# 20240224094002_add_name_fields_to_user.rb
class AddNameFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :given_name, :string
    add_column :users, :family_name, :string
  end
end
