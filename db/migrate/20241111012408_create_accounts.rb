# 20241111012408_create_accounts.rb
class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :display_name
      t.string :email
      t.jsonb :phone
      t.string :slug
      t.integer :status
      t.string :type
      t.string :tax_id
      t.text :readme
      t.jsonb :metadata

      t.timestamps
    end
  end
end
