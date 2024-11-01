class AddDescriptionToUsers < ActiveRecord::Migration[7.2]
  def change

    add_column :users, :bio, :string
    add_column :users, :username, :string

  end
end
