class CreateReturnReport < ActiveRecord::Migration[5.2]
  def change
    create_table :return_reports do |t|
      t.belongs_to :user
      t.bigint :approved_by_user_id
      t.json :products
      t.string :message

      t.timestamps
    end
  end
end
