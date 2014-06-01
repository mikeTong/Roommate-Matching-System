class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :univ_name
      t.integer :univ_id
      t.string :univ_addr

      t.timestamps
    end
  end
end
