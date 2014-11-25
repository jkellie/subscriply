class CreatePlanBulletpoints < ActiveRecord::Migration
  def change
    create_table :bulletpoints do |t|
      t.integer :plan_id
      t.string :icon
      t.string :title
      t.timestamps
    end
  end
end
