class CreateUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :uploads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file
      t.integer :file_size

      t.timestamps
    end
  end
end
