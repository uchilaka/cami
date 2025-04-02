# frozen_string_literal: true

# 20250215160028
class AddParentAccountFkToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :accounts,
                    :accounts,
                    column: :parent_account_id, validate: false,
                    index: { algorithm: :concurrently }
  end
end
