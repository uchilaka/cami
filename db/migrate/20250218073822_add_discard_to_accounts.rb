class AddDiscardToAccounts < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_column :accounts, :discarded_at, :datetime
    add_index :accounts, :discarded_at, algorithm: :concurrently
  end
end
