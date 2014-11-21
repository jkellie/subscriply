class AddSubtitleToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :subtitle, :string
  end
end
