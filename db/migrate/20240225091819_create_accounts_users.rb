# frozen_string_literal: true

class CreateAccountsUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :accounts, :users, column_options: { type: :uuid }, &:timestamps
  end
end
