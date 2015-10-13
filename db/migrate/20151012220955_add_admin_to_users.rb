class AddAdminToUsers < ActiveRecord::Migration
  # Since this is a boolean attribute rails automatically knows to create a method
  # .admin? which returns a boolean status of attribute
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
