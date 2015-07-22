class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.integer :city_id, null: false
      t.integer :state_id, null: false
      t.string :code, null: false
      t.string :long_name, null: false
      t.timestamps
    end
  end
end
