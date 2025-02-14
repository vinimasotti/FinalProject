class AddUserIdToSongs < ActiveRecord::Migration[7.2]
  def change
    add_column :songs, :user_id, :integer
  end
end
