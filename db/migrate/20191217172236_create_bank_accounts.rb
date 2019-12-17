class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :bank_name
      t.string :owner
      t.string :number
      t.string :interbank_clabe
      t.string :rfc
      t.string :email
    end
  end
end
