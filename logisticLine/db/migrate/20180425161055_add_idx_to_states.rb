class AddIdxToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :idx, :integer
  end
end
