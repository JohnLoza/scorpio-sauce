class CreateRouteStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :route_stocks do |t|
      t.belongs_to :user
      t.belongs_to :supply_order
      t.json :products

      t.timestamps
    end
  end
end
