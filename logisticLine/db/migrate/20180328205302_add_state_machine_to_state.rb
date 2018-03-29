class AddStateMachineToState < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :st_machine, :string
  end
end
