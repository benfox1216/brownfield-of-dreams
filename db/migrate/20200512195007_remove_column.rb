class RemoveColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :friends, :user_id
    remove_column :friends, :follow_user_id
  end
end
