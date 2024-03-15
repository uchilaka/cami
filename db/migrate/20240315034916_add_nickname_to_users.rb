# frozen_string_literal: true

# 20240315034916
class AddNicknameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nickname, :string
  end
end
