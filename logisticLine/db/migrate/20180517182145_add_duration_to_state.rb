class AddDurationToState < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :duration, :integer
  end
end
