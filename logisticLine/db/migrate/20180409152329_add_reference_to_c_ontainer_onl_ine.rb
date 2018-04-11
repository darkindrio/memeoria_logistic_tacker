class AddReferenceToCOntainerOnlIne < ActiveRecord::Migration[5.0]
  def change
    add_reference :lines, :container, index: true
  end
end
