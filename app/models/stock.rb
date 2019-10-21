class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse

  validates :units, :batch, :expiration_date, presence: true

  scope :available, -> (ammount = 1) { where("units >= ?", ammount) }
  scope :depleted, -> { where(units: 0) }
end
