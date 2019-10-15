class CreateStatesCities < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :name
    end

    create_table :cities do |t|
      t.belongs_to :state
      t.string :name
    end
  end
end
