class TicketDetail < ApplicationRecord
  belongs_to :product
  belongs_to :ticket

  validates :units, :batch, :sub_total presence: true
  validates :units, numericality: { only_integer: true, greater_than: 0 }
  validates :sub_total, numericality: { greater_than: 0 }
end
