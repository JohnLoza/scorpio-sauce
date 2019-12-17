class BankAccount < ApplicationRecord
  validates :bank_name, :owner, :interbank_clabe, :number, :email, :rfc, presence: true

  def to_s
    "#{bank_name} - #{number}"
  end
end
