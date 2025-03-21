# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :given_name
      t.string :family_name
      t.jsonb :profile, default: {}

      t.timestamps
    end
  end
end
