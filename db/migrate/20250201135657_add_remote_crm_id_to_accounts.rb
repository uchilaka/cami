# 20250201135657
class AddRemoteCrmIdToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :remote_crm_id, :string
  end
end
