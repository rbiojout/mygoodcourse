class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end

    add_index :peers, :follower_id
    add_index :peers, :followed_id
    add_index :peers, [:followed_id, :follower_id], :unique => true
  end
end
