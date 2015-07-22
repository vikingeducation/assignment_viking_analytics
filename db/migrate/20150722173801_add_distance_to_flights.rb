class AddDistanceToFlights < ActiveRecord::Migration
  def change

    add_column :flights, :distance, :integer, null: false
  end
end
