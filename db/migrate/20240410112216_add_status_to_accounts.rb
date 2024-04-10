# frozen_string_literal: true

# 20240410112216_add_status_to_accounts.rb
class AddStatusToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :status, :integer
  end
end
