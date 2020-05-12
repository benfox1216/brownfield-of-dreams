class ChangeFriendColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :friends, :friender_id, :user_id
    rename_column :friends, :friendee_id, :user_friend_id
  end
end
