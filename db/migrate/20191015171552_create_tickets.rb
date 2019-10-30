class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.belongs_to :user
      t.belongs_to :client
      t.decimal :total, precision: 10, scale: 2
      t.string :payment_method

      t.timestamps
    end
  end
end
