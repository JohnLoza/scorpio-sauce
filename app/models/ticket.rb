class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :client

  validates :total, :payment_method, presence: true
  validates :total, numericality: { greater_than: 0 }
  validates :payment_method, length: { maximum: 20 }
end
