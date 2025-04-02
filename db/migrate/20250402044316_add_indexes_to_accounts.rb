# frozen_string_literal: true

# 20250402044316_add_indexes_to_accounts.rb
class AddIndexesToAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    # Create partial index on email
    add_index :accounts,
              :email,
              unique: true,
              where: 'email IS NOT NULL',
              name: 'by_account_email_if_set',
              algorithm: :concurrently
    # Create partial index on tax_id
    add_index :accounts,
              :tax_id,
              unique: true,
              where: "tax_id IS NOT NULL AND TRIM(tax_id) != ''",
              name: 'by_account_tax_id_if_set',
              algorithm: :concurrently
  end
end
