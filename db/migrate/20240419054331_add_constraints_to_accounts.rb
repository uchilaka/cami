# frozen_string_literal: true

# 20240419054331_add_constraints_to_accounts.rb
class AddConstraintsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column :accounts, :tax_id, :string, null: true, unique: true
    change_column :accounts, :slug, :string, unique: true
  end
end
