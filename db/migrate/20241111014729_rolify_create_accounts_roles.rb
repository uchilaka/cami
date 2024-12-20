# frozen_string_literal: true

class RolifyCreateAccountsRoles < ActiveRecord::Migration[7.2]
  def change
    create_table(:accounts_roles, id: false) do |t|
      t.references :account, type: :uuid
      t.references :role, type: :uuid
    end

    add_index(:accounts_roles, %i[account_id role_id])
  end
end
