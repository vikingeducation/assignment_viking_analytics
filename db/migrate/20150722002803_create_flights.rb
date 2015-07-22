class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :origin_id, null: false
      t.integer :destination_id, null: false
      t.datetime :departure_time, null: false
      t.datetime :arrival_time, null: false
      t.float :price, null: false
      t.timestamps
    end
  end
end
