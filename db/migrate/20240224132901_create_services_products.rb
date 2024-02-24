# frozen_string_literal: true

class CreateServicesProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :services_products, id: :uuid do |t|
      t.references :service, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
    end
  end
end
