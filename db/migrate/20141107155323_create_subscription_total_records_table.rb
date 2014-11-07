class CreateSubscriptionTotalRecordsTable < ActiveRecord::Migration
  def change
    create_table :subscription_total_records do |t|
      t.integer :organization_id
      t.integer :plan_id
      t.integer :total
      t.date :created_at
    end
  end
end
