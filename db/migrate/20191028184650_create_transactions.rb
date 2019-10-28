class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.belongs_to :stock
      t.belongs_to :user
      t.boolean :incoming
      t.string :concept
      t.integer :units
      t.integer :units_post_transaction

      t.timestamps
    end
  end
end
