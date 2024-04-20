# frozen_string_literal: true

# 20240419054331_add_constraints_to_accounts.rb
class AddConstraintsToAccounts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :accounts, :slug, unique: true, algorithm: :concurrently
    add_index :accounts, :tax_id, unique: true, where: 'tax_id IS NOT NULL', algorithm: :concurrently
  end
end
