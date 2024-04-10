# frozen_string_literal: true

# 20240224131917_create_accounts.rb
class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :tax_id
      t.string :display_name, null: false
      # Doc on Rails STI: https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
      t.string :type, null: false

      t.timestamps
    end
  end
end
