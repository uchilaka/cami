class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid, &:timestamps
  end
end
