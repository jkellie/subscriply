class CreateTransactionsTable < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :subscription_id
      t.integer :user_id
      t.integer :invoice_id
      t.integer :amount_in_cents
      t.string :state
      t.string :transaction_type
      t.datetime :created_at
      t.uuid :uuid
    end
  end
end
