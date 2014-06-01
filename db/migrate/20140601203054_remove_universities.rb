class RemoveUniversities < ActiveRecord::Migration
  def change
  	drop_table :universities

  end
end
