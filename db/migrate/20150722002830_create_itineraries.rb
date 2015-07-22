class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.integer :user_id, null: false
      t.string :payment_method, null: false
      t.timestamps
    end
  end
end
