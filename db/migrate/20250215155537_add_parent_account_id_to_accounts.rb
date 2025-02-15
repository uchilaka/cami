# frozen_string_literal: true

class AddParentAccountIdToAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :accounts, :parent_account_id, :uuid
  end
end
