class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :description
      t.string :keywords

      t.timestamps
    end
  end
end
