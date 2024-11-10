# frozen_string_literal: true

# 20241110085506_add_omniauth_to_users.rb
class AddOmniauthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :providers, :string, array: true, default: []
    add_column :users, :uids, :jsonb, default: {}
  end
end
