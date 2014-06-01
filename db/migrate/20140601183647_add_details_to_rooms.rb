class AddDetailsToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :usr_name, :string
    add_column :rooms, :landlord, :string
    add_column :rooms, :image_url, :string
    add_column :rooms, :email, :string
    add_column :rooms, :tel, :decimal
  end
end
