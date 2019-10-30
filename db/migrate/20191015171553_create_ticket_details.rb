class CreateTicketDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_details do |t|
      t.belongs_to :ticket
      t.belongs_to :product
      t.integer :units
      t.string :batch
      t.decimal :sub_total, precision: 8, scale: 2
    end
  end
end
