# frozen_string_literal: true

# 20250219150823
class DeprecateParentAccountIdFromAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    safety_assured do
      remove_column :accounts, :parent_account_id, :uuid
    end
  end
end
