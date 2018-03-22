class CreateFriendships < ActiveRecord::Migration[5.1]
  def self.up
    create_table :friendships do |t|
      t.references :friendable, polymorphic: true
      t.integer :friend_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
