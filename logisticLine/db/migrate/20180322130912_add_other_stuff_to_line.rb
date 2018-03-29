class AddOtherStuffToLine < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :description, :string
    add_column :lines, :n_actors, :integer
    add_column :lines, :n_stages, :integer
  end
end
