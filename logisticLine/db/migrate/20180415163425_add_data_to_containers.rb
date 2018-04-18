class AddDataToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :travel_number, :string
    add_column :containers, :eta, :string
    add_column :containers, :storer, :string
    add_column :containers, :consignee, :string
    add_column :containers, :codename, :string
  end
end
