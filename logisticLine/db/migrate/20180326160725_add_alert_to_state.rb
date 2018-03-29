class AddAlertToState < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :alert, :string
  end
end
