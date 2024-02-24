# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :tax_id
      t.string :business_name, null: false
      t.text :readme

      t.timestamps
    end
  end
end
