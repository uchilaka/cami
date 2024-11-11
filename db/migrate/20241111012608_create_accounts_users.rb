# frozen_string_literal: true

# 20241111012608_create_accounts_users.rb
class CreateAccountsUsers < ActiveRecord::Migration[7.2]
  def change
    # this results in a join table :accounts_users with UUID FK columns account_id and user_id
    create_join_table :accounts, :users, column_options: { type: :uuid }, &:timestamps
  end
end
