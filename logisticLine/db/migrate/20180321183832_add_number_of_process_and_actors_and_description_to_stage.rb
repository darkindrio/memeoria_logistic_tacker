class AddNumberOfProcessAndActorsAndDescriptionToStage < ActiveRecord::Migration[5.0]
  def change
    add_column :stages, :description, :string
    add_column :stages, :n_actors, :integer
    add_column :stages, :n_process, :integer
  end
end
