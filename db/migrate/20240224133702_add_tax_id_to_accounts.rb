# frozen_string_literal: true

class AddTaxIdToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :tax_id, :string
  end
end
