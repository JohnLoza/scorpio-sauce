class CreateWarehouseShipments < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouse_shipments do |t|
      t.belongs_to :user
      t.bigint :receiver_user_id
      t.belongs_to :warehouse
      t.string :status
      t.json :products
      t.json :report

      t.timestamps
    end
  end
end
