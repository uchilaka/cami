# frozen_string_literal: true

# 20240315032751
class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :providers, :string, array: true, default: []
    add_column :users, :uids, :jsonb, default: {}
  end
end
