class AddUploadDataToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :upload_data, :integer, default: 0, null: false
  end
end
