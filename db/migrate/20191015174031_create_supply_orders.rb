class CreateSupplyOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_orders do |t|
      t.belongs_to :user
      t.bigint :target_user_id
      t.bigint :supplier_user_id
      t.belongs_to :warehouse
      t.json :to_supply
      t.string :status

      t.timestamps
    end
  end
end
