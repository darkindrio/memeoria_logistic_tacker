class AddNumerToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :number, :string
  end
end
