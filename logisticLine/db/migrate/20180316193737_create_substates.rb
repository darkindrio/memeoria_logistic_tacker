class CreateSubstates < ActiveRecord::Migration[5.0]
  def change
    create_table :substates do |t|
      t.string :name
      t.references :state, foreign_key: true

      t.timestamps
    end
  end
end
