class CreateInvoicesTable < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer   :user_id
      t.text      :href
      t.integer   :number
      t.integer   :total_in_cents
      t.datetime  :created_at
      t.uuid      :uuid
    end
  end
end
