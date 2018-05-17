class AddIdxToStage < ActiveRecord::Migration[5.0]
  def change
    add_column :stages, :idx, :integer
  end
end
