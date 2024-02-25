# frozen_string_literal: true

class CreateServicesProducts < ActiveRecord::Migration[7.0]
  def change
    create_join_table :services, :products, column_options: { type: :uuid }, &:timestamps
  end
end
