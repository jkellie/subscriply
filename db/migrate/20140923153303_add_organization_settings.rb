class AddOrganizationSettings < ActiveRecord::Migration
  def change
    add_column :organizations, :settings, :hstore
  end
end
