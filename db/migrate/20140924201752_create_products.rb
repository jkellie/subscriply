class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :organization_id
      t.string :name
      t.string :prepend_code
      t.text :description
      t.text :image
      t.timestamps
    end
  end
end
