class CreateSupplyOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_orders do |t|
      t.belongs_to :user
      t.bigint :target_user_id
      t.bigint :supplier_user_id
      t.json :to_supply
      t.json :supplies
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
