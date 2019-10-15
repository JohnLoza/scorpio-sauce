class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :retail_price, precision: 8, scale: 2
      t.decimal :half_wholesale_price, precision: 8, scale: 2
      t.decimal :wholesale_price, precision: 8, scale: 2
      t.integer :required_units_half_wholesale
      t.integer :required_units_wholesale
      t.json :boxes
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :products, :deleted_at
  end
end
