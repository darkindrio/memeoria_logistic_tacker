class CreateRecordStates < ActiveRecord::Migration[5.0]
  def change
    create_table :record_states do |t|
      t.belongs_to :state, index: true
      t.belongs_to :stage, index: true
      t.string :message

      t.timestamps
    end
  end
end
