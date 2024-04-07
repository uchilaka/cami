# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :tax_id
      t.string :display_name, null: false
      # Doc on Rails STI: https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
      t.string :type, null: false
      t.text :readme

      t.timestamps
    end
  end
end
