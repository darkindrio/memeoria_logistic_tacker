class AddNUmberOfActorsAndProcessAndDesriptionToState < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :description, :string
    add_column :states, :n_actors, :integer
    add_column :states, :n_sub_process, :integer
  end
end
