class AddUserReferencesToFriends < ActiveRecord::Migration[5.2]
  def change
    add_column :friends, :friender_id, :integer
    add_column :friends, :friendee_id, :integer
  end
end
