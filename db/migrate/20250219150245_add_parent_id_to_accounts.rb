# frozen_string_literal: true

class AddParentIdToAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :accounts, :parent_id, :uuid
  end
end
