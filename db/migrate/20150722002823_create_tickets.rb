class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :itinerary_id
      t.integer :flight_id
      t.timestamps
    end
  end
end
