class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :warehouse
      t.string :name
      t.string :email
      t.string :cellphone
      t.string :role
      t.string :password_digest
      t.string :recover_password_digest
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, :deleted_at
  end
end
