# frozen_string_literal: true

# 20250215155537
class AddParentAccountIdToAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :accounts, :parent_account_id, :uuid
  end
end
