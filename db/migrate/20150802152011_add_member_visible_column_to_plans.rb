class AddMemberVisibleColumnToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :member_visible, :boolean, null: false, default: true
  end
end
