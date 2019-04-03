class AddUniqueness < ActiveRecord::Migration[5.2]
  def change
    add_index :buses,    :number, unique: true
    add_index :cities,   :name,   unique: true
    add_index :services, :name,   unique: true

    add_index :buses_services, %i[bus_id service_id], unique: true
  end
end
