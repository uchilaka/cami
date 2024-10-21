# frozen_string_literal: true

# 20241020180811_add_primary_profile_id_to_user.rb
class AddPrimaryProfileIdToUser < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :users, :primary_profile_id, :string
    add_index :users,
              %i[id primary_profile_id],
              unique: true,
              if_not_exists: true,
              algorithm: :concurrently
  end
end
