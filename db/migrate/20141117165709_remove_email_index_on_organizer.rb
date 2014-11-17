class RemoveEmailIndexOnOrganizer < ActiveRecord::Migration
  def change
    remove_index :organizers, name: 'index_organizers_on_email'
    remove_index :users, name: 'index_users_on_email'
  end
end
