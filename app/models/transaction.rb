class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :user

  before_create { self.incoming = false unless self.incoming.present? }

  validates :concept, :units, :units_post_transaction, presence: true

  validates :units, :units_post_transaction,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
