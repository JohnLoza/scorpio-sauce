class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.belongs_to :product
      t.belongs_to :warehouse
      t.integer :units
      t.string :batch
      t.date :expires_at

      t.timestamps
    end
  end
end
