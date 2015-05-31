class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :location
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
