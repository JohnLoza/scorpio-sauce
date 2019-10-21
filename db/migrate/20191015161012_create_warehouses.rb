class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.string :address
      t.string :telephone
      t.belongs_to :city
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
