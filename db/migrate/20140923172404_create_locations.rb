class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :organization_id
      t.string :name
      t.string :street_address
      t.string :street_address_2
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
