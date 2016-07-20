class AddingAddress < ActiveRecord::Migration
  def change
    add_column :contacts, :address, :string
  end
end
