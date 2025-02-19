class DeprecateParentAccountIdFromAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    safety_assured do
      # remove_foreign_key :accounts, column: :parent_account_id
      remove_column :accounts, :parent_account_id, :uuid
    end
  end
end
