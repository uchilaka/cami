# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services, id: :uuid do |t|
      t.string :display_name, null: false
      t.text :readme

      t.timestamps
    end
  end
end
