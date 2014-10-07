class CreateSubscriptionsTable < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :organization_id
      t.integer :user_id
      t.integer :plan_id
      t.integer :location_id
      t.string  :state
      t.date :next_bill_on
      t.date :next_ship_on
      t.date :start_date
      t.date :canceled_on
      t.timestamps
    end
  end
end
