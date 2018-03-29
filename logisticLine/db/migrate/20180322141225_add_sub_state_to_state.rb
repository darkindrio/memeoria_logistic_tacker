class AddSubStateToState < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :sub_state, :string
  end
end
