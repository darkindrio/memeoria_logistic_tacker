class CreateContainersUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :containers_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :container, index: true
    end
  end
end
