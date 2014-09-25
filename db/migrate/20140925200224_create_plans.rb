class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :product_id
      t.integer :organization_id
      t.string :name
      t.string :code
      t.string :plan_type
      t.text :description
      t.boolean :send_renewal_reminders, default: true
      t.decimal :amount
      t.integer :charge_every, default: 1
      t.integer :free_trial_length, default: 30
      t.timestamps
    end
  end
end
