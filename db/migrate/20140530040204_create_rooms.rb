class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.primary_key :entry_id
      t.float :latitude
      t.float :longitude
      t.string :address
      t.decimal :rent
      t.decimal :util_fee
      t.integer :apt_roomnum
      t.integer :apt_bathnum
      t.string :apt_gender
      t.integer :univ_id
      t.integer :acpt_distance
      t.text :desc

      t.timestamps
    end
  end
end
