class AddPostIdToSongs < ActiveRecord::Migration[7.0]
  def change
    # First add the column allowing null values
    add_reference :songs, :post, foreign_key: true
    
    # Then backfill existing records with a default post
    reversible do |dir|
      dir.up do
        # Choose one of these options:
        
        # OPTION 1: Set all to a specific post (replace 1 with actual post ID)
        # Song.update_all(post_id: 1)
        
        # OPTION 2: Or if you want to allow null for now:
        change_column_null :songs, :post_id, true
      end
    end
    
    # Finally, if you really want the column to be non-nullable:
    # change_column_null :songs, :post_id, false
  end
end