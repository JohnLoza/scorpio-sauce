class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.belongs_to :user
      t.belongs_to :client
      t.decimal :total, precision: 10, scale: 2
      t.boolean :invoice_required, default: false
      t.string :payment_method
      t.string :cfdi
      t.boolean :canceled, default: false

      t.timestamps
    end
  end
end
