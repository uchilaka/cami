# frozen_string_literal: true

class AddParentFkToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :accounts,
                    :accounts,
                    column: :parent_id, validate: false,
                    index: { algorithm: :concurrently }
  end
end
