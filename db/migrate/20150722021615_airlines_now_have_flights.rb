class AirlinesNowHaveFlights < ActiveRecord::Migration
  def change
    add_column :flights, :airline_id, :integer, null: false
  end
end
