class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.belongs_to :user
      t.belongs_to :city
      t.string :name
      t.string :telephone
      t.string :address
      t.string :colony
      t.string :zc
      t.decimal :lat, precision: 8, scale: 6
      t.decimal :lng, precision: 9, scale: 6
      t.json :billing_data
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :clients, :deleted_at
  end
end
