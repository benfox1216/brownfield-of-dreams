class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.timestamps
      t.belongs_to :user
      t.belongs_to :follow_user
      t.index [:user_id, :follow_user_id], unique: true
    end
  end
end
