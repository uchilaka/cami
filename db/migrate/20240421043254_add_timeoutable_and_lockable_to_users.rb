# frozen_string_literal: true

# 20240421043254_add_timeoutable_and_lockable_to_users.rb
class AddTimeoutableAndLockableToUsers < ActiveRecord::Migration[7.0]
  def change
    # Setup timeoutable columns
    add_column :users, :last_request_at, :datetime
    add_column :users, :timeout_in, :integer, default: 30.minutes
    # Setup locable columns
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
  end
end
